module Network.Irc.Parse (parsePrivMsg, parsePing) where

import Data.Text

import Data.Attoparsec.Text
import Data.Attoparsec.Combinator

import Network.Irc.Types

privMsgParser :: Parser Message
privMsgParser = do
    char ':'
    nick <- takeTill $ \x -> x == '!'
    manyTill anyChar $ string "PRIVMSG "
    channel <- takeTill $ \x -> x == ' '
    string " :"
    message <- takeText
    return $ PrivMsg channel nick message

parsePrivMsg :: Text -> Either String Message
parsePrivMsg input = parseOnly privMsgParser input

pingParser :: Parser Message
pingParser = do
    string "PING "
    pingMsg <- takeText
    return $ Ping pingMsg

parsePing :: Text -> Either String Message
parsePing input = parseOnly pingParser input
