module Network.Irc.Configuration (Configuration 
    (Configure, nick, user, privMessageHandler))

where

import Data.Text
import Network.Irc.Types

data Configuration = Configure {
    nick :: Text,
    user :: Text,
    privMessageHandler :: (Channel -> Nick -> Message -> Maybe (Channel, Message))
}
