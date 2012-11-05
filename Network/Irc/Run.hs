module Network.Irc.Run (run) where

import Control.Monad.State

import Data.Text
import Data.Either
import Data.Maybe
import qualified Data.List

import Network.Irc.Configuration (Configuration)
import qualified Network.Irc.Configuration as C

import Network.Irc.Types 
import Network.Irc.Parse

run :: Configuration c => Text -> c s -> BotState s
run rawInput conf =
    let pm = case parsePrivMsg rawInput of
                (Right privMsg) -> runPrivMessageHandler privMsg conf
                otherwise -> return Nothing
        
        {-
        ping = case parsePing rawInput of
                 (Right ping) -> runPingHandler ping conf
                 otherwise -> return Nothing

    in findFirstParse [pm, ping]
    -}
    in pm
 
{-

findFirstParse :: [BotState s] -> BotState s
findFirstParse [] = return Nothing
findFirstParse (x:xs) = do
    s <- get
    case s of
        Just _ -> x
        Nothing -> findFirstParse xs
-}

runPingHandler :: Configuration c => Message -> c s -> BotState s
runPingHandler input conf = (C.pingMessageHandler conf) input

runPrivMessageHandler :: Configuration c => Message -> c s -> BotState s
runPrivMessageHandler privMsg conf = (C.privMessageHandler conf) privMsg
