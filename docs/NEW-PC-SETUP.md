# Moving to a new PC

The game, tests, Android project and release history are all in this GitHub repo. Three things are **not**, and they won't move unless you move them: your pilot saves, your Android signing key, and your installed tools.

## 1. On the old PC (before you wipe or retire it)

- [ ] **Push everything.** `git status` should show nothing to commit, and `git log origin/main..` should print nothing. Push any branch you want to keep, including `baseline/frontiers-2.0`.
- [ ] **Export your pilot.** Saves live in the browser's local storage (`farbound-save-v2` plus checkpoints) on each machine and origin. Browser sync does **not** carry them. In every browser or install you play in, open **Flight menu → Save progress → Export save** and keep the `.json` files. Do it once for the hosted game and once for `http://127.0.0.1:8080` if you have progress there too. If you still play it, the original v1 game in `classic/` keeps its own save.
- [ ] **Android signing key, if you made one.** `*.keystore` / `*.jks` files are gitignored on purpose, so they exist **only** on the old PC. Copy the keystore file, its alias and both passwords to a password manager and an offline drive. Lose it and you can't ship updates to an app signed with it. (No key is needed for debug builds.)
- [ ] **Android Studio settings (optional).** **File → Manage IDE Settings → Export Settings** keeps your editor setup. `android/local.properties` doesn't need copying; Android Studio recreates it.

## 2. On the new PC

### Windows (PowerShell)

```powershell
winget install --id Git.Git -e
winget install --id OpenJS.NodeJS.LTS -e
winget install --id Google.AndroidStudio -e   # only for the native APK
# open a NEW terminal so git/node are on PATH
mkdir $HOME\code; cd $HOME\code
git clone https://github.com/GabeTC99/Nullharbor.git
git clone https://github.com/GabeTC99/voidwake-site.git
cd Nullharbor
powershell -ExecutionPolicy Bypass -File scripts\setup.ps1 -Serve
```

`setup.ps1` checks Git and Node, runs `node --check` and all four test suites, warns if Android Studio is missing, and with `-Serve` starts the local server at http://127.0.0.1:8080. `-Install` installs any missing Git and Node through winget for you.

### macOS / Linux / WSL

```sh
git clone https://github.com/GabeTC99/Nullharbor.git
cd Nullharbor && ./scripts/setup.sh
python3 -m http.server 8080 -d dist
```

### Bring your pilot back

Open the game (hosted or local), then **Flight menu → Restore a pilot** and choose the exported `.json`.

### Native Android build

Follow "Build the native Android app" in the README: open `android/` in Android Studio, set **JDK 17, SDK 35, Gradle 8.9**, then run `gradle wrapper --gradle-version 8.9` and `./gradlew assembleDebug`. For release builds, point Android Studio at the keystore you copied over.

### Git identity (first time only)

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## Done when

- The setup script finishes with "Ready." (every suite reports all checks passed).
- The game runs locally and your imported pilot has its credits, ships and progress.
- `git push` from the new PC works.
