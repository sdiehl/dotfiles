module Main (main) where

import XMonad
import Graphics.X11.Xlib
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Hooks.SetWMName

main :: IO ()

myBorderWidth   = 5
myNumlockMask   = mod2Mask
 
main = xmonad defaultConfig
        { modMask = mod4Mask -- Use Super instead of Alt
        , terminal = "sakura"
        , keys = newKeys
        , startupHook = setWMName "LG3D"
        , borderWidth = myBorderWidth
        }
        
myWorkspaces = ["1","2","3","4","5","6","7","8","9","0"]

newKeys x = M.union (keys defaultConfig x) (M.fromList (myKeys x))

myKeys conf@(XConfig {XMonad.modMask = modm}) =
     [ 
        ((modm, xK_F11), spawn "sakura")
        , ((modm, xK_x), spawn "xscreensaver-command -lock")
        , ((modm, xK_F1), spawn "ncmpcpp next")
        , ((modm, xK_F2), spawn "ncmpcpp toggle")
        , ((modm, xK_grave), spawn "xterm -e vifm")
     ]
     ++
     [((m .|. modm, k), 
      windows $ f i) | (i, k) <- zip myWorkspaces numPadKeys , 
      (f, m) 
     <- [(W.greedyView, 0), (W.shift, shiftMask)]]
        
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
             , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
             , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
             , xK_KP_Insert]                            -- 0 
