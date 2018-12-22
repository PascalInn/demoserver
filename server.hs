import Network
import System.IO
import qualified Data.ByteString as B

main = do
  sock <- listenOn (PortNumber (fromIntegral 10000))
  loop sock

loop sock = withSocketsDo $ do
  (hIn, host, port) <- accept sock
  sendTo host (PortNumber port) "I'm server"
  loop sock
