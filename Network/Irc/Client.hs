module Network.Irc.Client (runClient) where

import Prelude hiding (putStrLn)

import Control.Monad.State

import Network
import System.IO hiding (hPutStrLn, hPutStr, hGetLine, putStrLn)

import Data.Text.IO

import Network.Irc.Types

import Network.Irc.Configuration (Configuration)
import qualified Network.Irc.Configuration as C

import Network.Irc.Run


ircNewlineMode = NewlineMode { inputNL = CRLF, outputNL = CRLF }

runClient :: Configuration c => c s -> BotState s -> IO ()
runClient conf initialState = withSocketsDo $ do
    h <- connectTo (C.server conf) (PortNumber $ toEnum (C.port conf))
    hSetBuffering h LineBuffering
    hSetNewlineMode h ircNewlineMode

    -- Initialization
    let loginInfo = C.generateLoginInfo conf
    -- putStrLn loginInfo
    hPutStr h loginInfo

    runLoop conf h initialState

runLoop :: Configuration c => c s -> Handle -> BotState s -> IO ()
runLoop conf h currentState = do
    line <- hGetLine h
    let (val, nextState) = runState (run line conf) currentState
    case val of
        Nothing -> return ()
        Just outputMessage -> hPutStrLn h $ messageToText outputMessage
    
    let newState = state (\x -> (val, nextState))
    runLoop conf h newState
