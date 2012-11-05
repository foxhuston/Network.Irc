module Network.Irc.Configuration
    (Configuration 
        (nick, user, privMessageHandler, server, port, defaultChannel, pingMessageHandler),
     generateLoginInfo)

where

import Data.Text
import Network.Irc.Types

class Configuration c where
    nick :: c s -> Text
    nick _ = "TestBot"

    user :: c s -> Text
    user _ = "Test Bot Test"

    privMessageHandler :: c s -> (Message -> BotState s)

    pingMessageHandler :: c s -> (Message -> BotState s)
    pingMessageHandler _ = \(Ping t) -> return $ Just $ Pong t

    server :: c s -> String

    port :: c s -> Int

    defaultChannel :: c s-> Text

generateLoginInfo :: Configuration c => c s -> Text
generateLoginInfo conf = Data.Text.concat 
    ["USER * . 0 :", user conf,
     "\r\n", "NICK ", nick conf,
     "\r\n", "JOIN ", defaultChannel conf,
     "\r\n"]
