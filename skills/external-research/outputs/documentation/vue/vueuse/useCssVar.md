[Skip to content](https://vueuse.org/core/useCssVar/#VPContent)

On this page

# useCssVar [​](https://vueuse.org/core/useCssVar/\#usecssvar)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

796 B

Last Changed

7 months ago

Manipulate CSS variables

## Demo [​](https://vueuse.org/core/useCssVar/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useCssVar/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNp9ksFOwzAMhl/FKodu0saQAAFlRaC9ASBOvYTgsogsqZq0gKq+O06TdRls5Jb4/2N/trvkoapO2waTLFkaXovKgkHbVCCZes+LxJoiuSuU2FS6ttBBY3BlzAuroYey1htI78lNrwuua0wjpVkzKfXnI5Yz53rGTSWZRbqPVnKSo1BcK2MBJeS/lJMUZTrdCriWuvYaX8Mknc+Hx3RGbtIVqmwUt0IrMJ/C8vXKRSdT6AoFIEqYDPLTlskGIc9zSE/eyuvLi3OXBejsxSl6VbKbm2uqEiiDwcOi8EWh+pimPYjT7ng+8Jskuz7tcPaRX1joTKAmn+NtSTXi8jXNC100giVhjBr97iii6Biba+VGEsMeknnU5cJvDO0HXWzgpBvA8k20UGNJG4SySMDYb4l0Cf4MQmNvPWEGLVUegtNh41zqJ0ZfIlj8sjPourAAPaWmDAtK4XO9NtZSC+65FPyDkkSjH79aDf0B/zjYvetvte2/5UZ9olc/+FtyZFtLqDLbja4/yuMWoO+zEW1QH6Hb/r9h9btQc4mlzeDMpR65xx04SA0UEOxVDmON8JeLaHJJ/wOS9lvv)

Sample text, #7fa998

Change Color

Sample text, --color: #7fa998

Change Color Variable

## Usage [​](https://vueuse.org/core/useCssVar/\#usage)

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
('el')
const
=
('--color',
)

const
=
('elv')
const
=
('--color')
const
=
(
,
)

const
=
('someEl')
const
=
('--color',
, {
: '#eee' })
```

## Type Declarations [​](https://vueuse.org/core/useCssVar/\#type-declarations)

ts

```
export interface UseCssVarOptions extends ConfigurableWindow {

?: string
  /**
   * Use MutationObserver to monitor variable changes
   * @default false
   */

?: boolean
}
/**
 * Manipulate CSS variables.
 *
 * @see https://vueuse.org/useCssVar
 * @param prop
 * @param target
 * @param options
 */
export declare function
(

:
<string | null | undefined>,

?:
,

?: UseCssVarOptions,
):
<string | undefined, string | undefined>
```

## Source [​](https://vueuse.org/core/useCssVar/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useCssVar/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useCssVar/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useCssVar/index.md)
