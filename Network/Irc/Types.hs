module Network.Irc.Types
    (Nick,
     Channel,
     Message (PrivMsg, Ping, Pong),
     messageToText,
     BotState)
where

import Control.Monad.State
import Data.Text

type Nick = Text
type Channel = Text
data Message = 
    PrivMsg Channel Nick Text |
    Ping Text |
    Pong Text

messageToText :: Message -> Text
messageToText (PrivMsg channel _ message) = Data.Text.concat ["PRIVMSG ", channel, " :", message]

messageToText (Ping message) = Data.Text.concat ["PING ", message]

messageToText (Pong message) = Data.Text.concat ["PONG ", message]

type BotState s = State s (Maybe Message)
