module Main (main) where

import Control.Concurrent (forkFinally)
import qualified Control.Exception as E
import Control.Monad (unless, forever, void)
import qualified Data.ByteString as S
import Network.Socket hiding (recv)
import Network.Socket.ByteString (recv, sendAll)

main :: IO()
main = withSocketsDo $ do
  addr <- resolve "3000"
  E.bracket (open addr) close loop
  where
    resolve port = do
      let hints = defaultHints {
        addrFlags = [AI_PASSIVE],
        addrSocketType = Stream}
      addr:_<-getAddrInfo (Just hints) Nothing (Just port)
      return addr
    open addr = do
      sock <- socket (addrFamily addr) (addrSocketType addr)(addrProtocol addr)
      setSocketOption sock ReuseAddr 1
      bind sock (addrAddress addr)
      listen sock 10000
      return sock
    loop sock = forever $ do
      (conn, peer) <- accept sock
      putStrLn $ "Connection from" ++ show peer
      void $ forkFinally (talk conn) (\_ -> close conn)
    talk conn = do
      msg <- recv conn 1024
      unless (null msg) $ do
        sendAll conn msg
        talk conn
