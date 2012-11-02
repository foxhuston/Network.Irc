{-# LANGUAGE OverloadedStrings #-}

module Network.Irc.Run (run, generateLoginInfo) where

import Data.Text
import Data.Either
import Data.Maybe
import qualified Data.List

import Network.Irc.Configuration (Configuration)
import qualified Network.Irc.Configuration as C

import Network.Irc.Types 
import Network.Irc.Parse

maybeGenerateMessage :: Configuration c => Maybe (Channel, Message) -> c -> Maybe Text
maybeGenerateMessage Nothing _ = Nothing
maybeGenerateMessage (Just(channel, message)) conf = return $
    Data.Text.concat ["PRIVMSG ", channel, " :", message]


generateLoginInfo :: Configuration c => c -> Text
generateLoginInfo conf = Data.Text.concat 
    ["USER * . 0 :", C.user conf,
     "\r\n", "NICK ", C.nick conf,
     "\r\n", "JOIN ", C.defaultChannel conf,
     "\r\n"]


run :: Configuration c => Text -> c -> Maybe Text
run rawInput conf = 
    let pm = case parsePrivMsg rawInput of
                (Right (c, n, m)) -> runPrivMessageHandler c n m conf
                otherwise -> Nothing
        
        ping = case parsePing rawInput of
                 (Right t) -> runPingHandler t conf
                 otherwise -> Nothing

    in fromMaybe Nothing $ Data.List.find isJust [pm, ping]

runPingHandler :: Configuration c => Text -> c -> Maybe Text
runPingHandler input conf = (C.pingMessageHandler conf) input

runPrivMessageHandler :: Configuration c => Channel -> Nick -> Message -> c -> Maybe Text
runPrivMessageHandler channel nick message conf = let
        maybeMessage = (C.privMessageHandler conf) channel nick message
    in maybeGenerateMessage maybeMessage conf
    
