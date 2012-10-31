module Network.Irc.Run (run) where

import Network.Irc.Configuration (Configuration)
import qualified Network.Irc.Configuration as C

import Network.Irc.Types 
import Network.Irc.Parse


maybeGenerateMessage :: Maybe (Channel, Message) -> Configuration -> Maybe String
maybeGenerateMessage Nothing _ = Nothing
maybeGenerateMessage (Just (channel, message)) conf = return $
    ":" ++ (C.nick conf) ++ "!~" ++ (C.user conf) ++ " PRIVMSG "
        ++ channel ++ " :" ++ message


run :: String -> Configuration -> Maybe String
run rawInput conf
    | isPrivMsg rawInput = runPrivMessageHandler rawInput conf
    | otherwise = Nothing


runPrivMessageHandler :: String -> Configuration -> Maybe String
runPrivMessageHandler rawInput conf = let
        (channel, nick, message) = parsePrivMsg rawInput
        maybeMessage = (C.privMessageHandler conf) channel nick message
    in maybeGenerateMessage maybeMessage conf
    

parsePrivMsg :: String -> (Channel, Nick, Message)
parsePrivMsg _ = ("#optacular", "fox", "This is a test")


isPrivMsg :: String -> Bool
isPrivMsg _ = True
