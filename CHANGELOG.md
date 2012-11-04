## 1.1.3 (Nov 04, 2012)

Point to new github home (moved to 'outfiedling' organization)

## 1.1.2 (Apr 10, 2012)

We need to be in the glorious prescence of a capistrano instance to load capistrano things. Else rake tasks go boom.

## 1.1.1 (Apr 10, 2012)

Forgot template changes to remove ssl_verify

## 1.1.0 (Apr 10, 2012)

Switched to [broach](https://github.com/Manfred/broach) instead of [tinder](https://github.com/collectiveidea/tinder) due to Tinder's reliance on ActiveSupport and the side-effect issues of ActiveSupport with capistrano (See [Issue #169](https://github.com/capistrano/capistrano/issues/169), [Issue #170](https://github.com/capistrano/capistrano/issues/170), and [Pull Request #175](https://github.com/capistrano/capistrano/pull/175) )
