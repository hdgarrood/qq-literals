{-# LANGUAGE QuasiQuotes #-}

import Spec.Example (uri)
import Network.URI (URI(..))

main :: IO ()
main = do
  let exampleDotCom = [uri|http://example.com/lol|]
  putStrLn ("scheme: " ++ uriScheme exampleDotCom)
  putStrLn ("authority: " ++ show (uriAuthority exampleDotCom))
  putStrLn ("path: " ++ uriPath exampleDotCom)
