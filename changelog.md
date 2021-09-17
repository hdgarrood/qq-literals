## v0.1.0.2

- Re-export QuasiQuoter to enable user to not depend on template-haskell.

## v0.1.0.1

- Use MonadFail Q instance instead of the previous MonadFail (String -> Q), which was being used accidentally. Should allow building on GHC 8.8 and above. (@bergey, #3)

## v0.1.0.0

- Initial release
