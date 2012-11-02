{-# LANGUAGE OverloadedStrings #-}

module Network.Irc.Parse (isPrivMsg, parsePrivMsg, parsePing) where

import Data.Text

import Data.Attoparsec.Text
import Data.Attoparsec.Combinator

isPrivMsg :: Text -> Bool
isPrivMsg = isInfixOf " PRIVMSG "

privMsgParser :: Parser (Text, Text, Text)
privMsgParser = do
    char ':'
    nick <- takeTill $ \x -> x == '!'
    manyTill anyChar $ string "PRIVMSG "
    channel <- takeTill $ \x -> x == ' '
    string " :"
    message <- takeText
    return (channel, nick, message)

parsePrivMsg :: Text -> Either String (Text, Text, Text)
parsePrivMsg input = parseOnly privMsgParser input

pingParser :: Parser Text
pingParser = do
    string "PING "
    takeText

parsePing :: Text -> Either String Text
parsePing input = parseOnly pingParser input
