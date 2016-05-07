{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RecordWildCards #-}
module QQLiterals where

import Language.Haskell.TH (appE, varE, stringE, Q, Name, reify)
import Language.Haskell.TH.Quote (QuasiQuoter(..))

qqLiteral :: (String -> Either String a) -> Name -> QuasiQuoter
qqLiteral parse parseFn = QuasiQuoter {..}
  where
  quoteExp str =
    case parse str of
      Right _ -> [| case $(varE parseFn) str of { Right x -> x } |]
      Left err -> fail err

  quotePat  = unsupported "pattern"
  quoteType = unsupported "type"
  quoteDec  = unsupported "declaration"

  unsupported context = fail $
    "Unsupported operation: this QuasiQuoter can not be used in a " ++ context ++ " context."
