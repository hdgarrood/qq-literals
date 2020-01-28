{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RecordWildCards #-}
-- |
-- This module gives you a way of easily constructing QuasiQuoters for literals
-- of any type @a@ for which you can write a parsing function @String -> Either
-- String a@.
--
module QQLiterals where

import Language.Haskell.TH (varE, Name)
import Language.Haskell.TH.Quote (QuasiQuoter(..))

-- |
-- The qqLiteral function takes two arguments. The first is a function which
-- parses values of the type we’re interested in, which should return a 'Right'
-- value in case of success, or a 'Left' value with an error message in case of
-- failure. The second is a 'Name', which must refer to the same function
-- passed as the first argument. It is recommended to use Template Haskell
-- quoting to provide the second argument; see below.
--
-- The resulting 'QuasiQuoter' applies the quoted string to the parsing
-- function at compile time, and if parsing succeeds, an expression equivalent
-- to @fromRight (parse str)@ is spliced into the program. If parsing fails,
-- this causes an error at compile time.
--
-- As long as the parsing function isn't lying about being pure, this should
-- always be safe, in that it should never result in an error at runtime.
--
-- For example, suppose we wanted to be able to define literals for the @URI@
-- type in @network-uri@. The function @parseURI@ from @network-uri@ has
-- type @String -> Maybe URI@, so we first need to define an 'Either' version:
--
-- @
-- eitherParseURI :: String -> Either String URI
-- eitherParseURI str =
--   maybe (Left ("Failed to parse URI: " ++ str)) Right (parseURI str)
-- @
--
-- We can then use the 'qqLiteral' function to create our 'QuasiQuoter'. Note
-- that we use a single-quote character to quote @eitherParseURI@ in order to
-- provide the 'Name' argument; this will require the @TemplateHaskell@
-- extension to be enabled.
--
-- @
-- uri :: QuasiQuoter
-- uri = qqLiteral eitherParseURI 'eitherParseURI
-- @
--
-- And it can be used as follows:
--
-- @
-- exampleDotCom :: URI
-- exampleDotCom = [uri|http:\/\/example.com\/lol|]
-- @
--
qqLiteral :: (String -> Either String a) -> Name -> QuasiQuoter
qqLiteral parse parseFn = QuasiQuoter {..}
  where
  quoteExp str =
    case parse str of
      Right _ -> [| case $(varE parseFn) str of { Right x -> x; Left x -> error ("can't happen: " ++ show x)} |]
      Left err -> fail err

  quotePat  = unsupported "pattern"
  quoteType = unsupported "type"
  quoteDec  = unsupported "declaration"

  unsupported context _ = fail $
    "Unsupported operation: this QuasiQuoter can not be used in a " ++ context ++ " context."
