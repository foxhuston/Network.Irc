module Network.Irc.Client (runClient) where

import Prelude hiding (putStrLn)

import Network
import System.IO hiding (hPutStrLn, hPutStr, hGetLine, putStrLn)

import Data.Text.IO

import Network.Irc.Configuration (Configuration)
import qualified Network.Irc.Configuration as C

import Network.Irc.Run

import Control.Monad.Fix (fix)

ircNewlineMode = NewlineMode { inputNL = CRLF, outputNL = CRLF }

runClient :: Configuration c => c -> IO ()
runClient conf = withSocketsDo $ do
    h <- connectTo (C.server conf) (PortNumber $ toEnum (C.port conf))
    hSetBuffering h LineBuffering
    hSetNewlineMode h ircNewlineMode

    -- Initialization
    let loginInfo = generateLoginInfo conf
    putStrLn loginInfo
    hPutStr h loginInfo

    fix $ \loop -> do
        line <- hGetLine h
        putStrLn line
        case (run line conf) of
            Nothing -> return ()
            Just outputMessage -> do
                putStrLn outputMessage
                hPutStrLn h outputMessage
        loop
