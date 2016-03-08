:Namespace ImageFilters

      LoadImage←{
          f←⎕NEW'Form'(('Caption'('SOURCE - ',⍵))('Size'(40 80))('Posn'(50 0)))
          f.mb←f.⎕NEW⊂'MenuBar'
          f.mf←f.mb.⎕NEW'Menu'(⊂'Caption' 'Filters')
          f.filters←f.mf.{
              ⎕NEW'MenuItem'(('Caption'⍵)('Style' 'Check'))
          }¨Filters.⎕NL ¯3
          f.filters.onSelect←⊂'applyFilter'f
          f.sbmp←f.⎕NEW'Bitmap'(⊂'File'⍵)
          f.tbmp←f.⎕NEW'Bitmap'(⊂'CBits'f.sbmp.CBits)
          f.simg←f.⎕NEW'Image'(('Picture'f.sbmp)('Size'(100 50))('Points'(0 0)))
          f.timg←f.⎕NEW'Image'(('Picture'f.tbmp)('Size'(100 50))('Points'(0 50)))
          f.Wait
      }

      applyFilter←{
          f←⍺
          mi←⊃⍵
          newState←~mi.Checked
          mi.Checked←newState
          active←f.(filters.Checked/filters.Caption)
          f.tbmp.CBits←active Filters.{0∊⍴⍺:⍵ ⋄ (¯1↓⍺)∇(⍎⊃⌽⍺)⍵}f.sbmp.CBits
          0
      }

      tessellate←{⎕IO←⎕ML←0
          R←⍴⍵
          k←≢R
          r←1+(-k)↑¯1+⍺
          s←⌈R÷r
          R←r×s
          ⊂[1+2×⍳k](,s,⍪r)⍴R↑⍵
⍝ ⍺ shape of sub arrays
⍝ ⍵ multi-d array
⍝ ← nested array of ⍺ shaped subarrays of ⍵
⍝   if ⍺ is shorter than rank ⍵ it is padded at left with ones.
⍝   if any ⍺ is not a factor of ⍴⍵, ⍵ is padded to make it so.
      }

      rgb_avg←{
          256⊥⌊0.5+(≢,⍵)÷⍨+/+/(3/256)⊤⍵
      }

    :Namespace Filters
          Duplo←{⎕IO←0
              ⍺←8
              row_avg←{⊃,/{(⍴r)⍴##.rgb_avg⊢r←⊃,/⍵}¨⍺⊂⍵}
              blocks←(4 3×⌊⍺)##.tessellate ⍵
              masks←1,1↓[1]2|+/¨⍳⍴blocks
              mat←⊃⍪/(↓masks)row_avg¨↓blocks
              mat
          }

          Grayscale←{
              out←(3/256)⊤⍵
              out←↑3/⊂⌈0.2 0.71 0.07+.×out
              256⊥out
          }

          HFlip←{
              ⌽⍵
          }

          VFlip←{
              ⊖⍵
          }

          Invert←{
              16777215-⍵
          }

          Pixelate←{
⍝ Group the CBits into size×size blocks and averages them
              ⍺←8
              size←⍺
              h w←⍴⍵
              out←(size|h)↓⍵
              out←(size|w)↓[2]out
              out←(2/size)##.tessellate out
              out←##.rgb_avg¨out
              out←size/size⌿out
            ⍝ out←{3/⌈(+/0.2 0.71 0.07×⊃⍵)}¨out
            ⍝ out←{256⊥⍵}¨out
              out
          }

          RemoveBlue←{
              256⊥1 1 0×[1](3/256)⊤⍵
          }

          RemoveGreen←{
              256⊥1 0 1×[1](3/256)⊤⍵
          }

          RemoveRed←{
              256⊥0 1 1×[1](3/256)⊤⍵
          }
          
          ColourSwap←{
              split←(3/256)⊤⍵
              split←1⌽[1]split
              256⊥split
          }

          Sepia←{
              m←↑(0.393 0.769 0.189)(0.349 0.686 0.168)(0.272 0.534 0.131)
              256⊥255⌊⌊m+.×(3/256)⊤⍵
          }
    :EndNamespace

:EndNamespace