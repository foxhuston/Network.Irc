{-# LANGUAGE OverloadedStrings #-}

module Network.Irc.Run (run) where

import Data.Text

import Network.Irc.Configuration (Configuration)
import qualified Network.Irc.Configuration as C

import Network.Irc.Types 
import Network.Irc.Parse


maybeGenerateMessage :: Maybe (Channel, Message) -> Configuration -> Maybe Text
maybeGenerateMessage Nothing _ = Nothing
maybeGenerateMessage (Just (channel, message)) conf = return $
    Data.Text.concat ["PRIVMSG ", channel, " :", message]


run :: Text -> Configuration -> Maybe Text
run rawInput conf
    | isPrivMsg rawInput = runPrivMessageHandler rawInput conf
    | otherwise = Nothing


runPrivMessageHandler :: Text -> Configuration -> Maybe Text
runPrivMessageHandler rawInput conf = let
        (channel, nick, message) = parsePrivMsg rawInput
        maybeMessage = (C.privMessageHandler conf) channel nick message
    in maybeGenerateMessage maybeMessage conf
    
