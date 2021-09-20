## v0.1.1.0

- Re-export the QuasiQuoter type in order to allow users to avoid depending on template-haskell. (@TristanCacqueray, #4)

## v0.1.0.1

- Use MonadFail Q instance instead of the previous MonadFail (String -> Q), which was being used accidentally. Should allow building on GHC 8.8 and above. (@bergey, #3)

## v0.1.0.0

- Initial release
