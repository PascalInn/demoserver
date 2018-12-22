import Network
import System.IO
import Graphics.Gloss.Interface.IO.Game
import qualified Data.ByteString as B

main = withSocketsDo $ do
  a<-connectTo "000.0.0.0" (PortNumber (fromIntegral 10000))
  b<-recvFrom "000.0.0.0" (PortNumber (fromIntegral 10000))
  print b

