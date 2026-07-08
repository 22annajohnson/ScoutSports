# CI Caching

Scout CI uses conservative dependency caching only where cache keys are easy to reason about and cache misses still behave like clean installs.

## Bundler

The `Swift Tests` job caches Bundler-installed gems in `Scout/vendor/bundle`.

Cache key:

```text
${{ runner.os }}-bundler-${{ hashFiles('Scout/Gemfile.lock') }}
```

Invalidation assumptions:

- The cache is scoped by runner operating system so macOS gems are not shared with Linux jobs.
- `Scout/Gemfile.lock` changes create a new cache key.
- Restore keys may reuse an older Bundler cache on the same runner OS, but `bundle install` still reconciles the restored cache against the committed lockfile.
- Cache misses are safe and fall back to a normal Bundler install.

## Deferred Caches

DerivedData, build products, simulator state, and other Xcode outputs are intentionally not cached in the initial CI foundation. Those caches can reduce runtime, but they are more likely to hide clean-build failures or create confusing invalidation behavior. Add them only through a follow-up plan once the baseline workflows are stable.
