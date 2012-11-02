{-# LANGUAGE OverloadedStrings #-}

module Network.Irc.Parse (isPrivMsg, parsePrivMsg) where

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

parsePrivMsg :: Text -> (Text, Text, Text)
parsePrivMsg input =
    let
        output (Done _ r) = r
        output (Partial f) = output $ f ""
    in output $ parse privMsgParser input
