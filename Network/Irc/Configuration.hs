module Network.Irc.Configuration
    (Configuration (nick, user, privMessageHandler),
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
    privMessageHandler _ = (\c _ m -> Just (c, m))

data EchoBotConfiguration = EchoBotConfiguration

instance Configuration EchoBotConfiguration
