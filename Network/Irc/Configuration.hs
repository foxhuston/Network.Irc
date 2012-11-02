module Network.Irc.Configuration
    (Configuration (nick, user, privMessageHandler, server, port, defaultChannel, pingMessageHandler),
     EchoBotConfiguration (EchoBotConfiguration))

where

import Data.Text
import Network.Irc.Types

class Configuration c where
    nick :: c -> Text
    nick _ = "TestBot"

    user :: c -> Text
    user _ = "Test Bot Test"

    privMessageHandler :: c -> (Channel -> Nick -> Message -> Maybe (Channel, Message))

    pingMessageHandler :: c -> (Text -> Maybe Text)
    pingMessageHandler _ = \t -> Just $ Data.Text.concat ["PONG ", t]

    server :: c -> String

    port :: c -> Int

    defaultChannel :: c -> Text
