# Salah Time

Salah Time is a GNU Emacs package that lets  you see [salah time](https://en.wikipedia.org/wiki/Salah) in Emacs:


![salah-time](https://user-images.githubusercontent.com/17734314/51439081-c46cd280-1ce7-11e9-9d53-32fde98aae73.png)

## Installation

Grab Salah time, put it in your load-path, then:

```elisp
(require 'salah-time)

```

Or with use-package:

``` elisp
(use-package salah-time
  :load-path "~/emacs-packages/salah-time")
```

## Usage

First you need to define your city location. e.g:

``` elisp
(setq salah-time-city "Surabaya")
```

So your configuration might be:

``` elisp
(use-package salah-time
  :load-path "~/emacs-packages/salah-time"
  :config
  (setq salah-time-city "Surabaya"))
```

Then invoke with `M-x salah-time`, you will be prompted by "Salah:" in
minibuffer. Put the value defined below:

Alias  |  Salah Name
:-----:|:-------------------------:
 s     |  Fajr
 d     |  Dhuhr
 a     |  Asr
 m     |  Maghrib
 i     |  Isha

You only need to input the alias, so you don't need to type complete salah name.
