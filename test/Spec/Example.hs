{-# LANGUAGE TemplateHaskell #-}
module Spec.Example where

import Network.URI (URI, parseURI)
import Language.Haskell.TH.Quote (QuasiQuoter)
import QQLiterals (qqLiteral)

eitherParseURI :: String -> Either String URI
eitherParseURI str =
  maybe (Left ("Failed to parse URI: " ++ str)) Right (parseURI str)

uri :: QuasiQuoter
uri = qqLiteral eitherParseURI 'eitherParseURI
