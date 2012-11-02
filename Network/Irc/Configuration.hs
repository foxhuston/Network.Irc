module Network.Irc.Configuration
    (Configuration (nick, user, privMessageHandler, server, port, defaultChannel),
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

    server :: c -> String

    port :: c -> Int

    defaultChannel :: c -> Text

data EchoBotConfiguration = EchoBotConfiguration

instance Configuration EchoBotConfiguration where

    privMessageHandler _ = (\c _ m -> Just (c, m))

    server _ = "aye.ayecapta.in"

    port _ = 7000

    defaultChannel _ = "#bottest"
