import           Distribution.Simple
import           Distribution.Simple.Setup (Flag (..), HaddockFlags,
                                            haddockDistPref)
import           Distribution.Simple.Utils (copyFiles)
import           Distribution.Text         (display)
import           Distribution.Verbosity    (normal)
import           System.FilePath           ((</>))

-- Ugly hack, logic copied from Distribution.Simple.Haddock
haddockOutputDir :: Package pkg => HaddockFlags -> pkg -> FilePath
haddockOutputDir flags pkg = destDir
   where
     baseDir = case haddockDistPref flags of
                      NoFlag -> "."
                      Flag x -> x
     destDir = baseDir </> "doc" </> "html" </> display (packageName pkg)

main :: IO ()
main = defaultMainWithHooks simpleUserHooks {
    postHaddock = \args flags pkg lbi -> do
        copyFiles normal (haddockOutputDir flags pkg) [("diagrams","greenCircle.svg")]
        postHaddock simpleUserHooks args flags pkg lbi
  }
