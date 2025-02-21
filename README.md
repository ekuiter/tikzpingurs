# Ti*k*ZpingURS

[![made-with-latex](https://img.shields.io/badge/Made%20with-LaTeX-1f425f.svg)](https://www.latex-project.org/) [![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/GPL-3.0)

Clearly, one should be able to show off the diversity of (cute) little penguins that can be typeset with [Ti*k*Zpingus](https://github.com/EagleoutIce/tikzpingus).
Something like this:

<picture><source media="(prefers-color-scheme: dark)" srcset="images/pingus-dark.svg"><img src="images/pingus.svg" width="100%"></picture>

But it's impossible to highlight every penguin in (potential) existence, as there are simply too many.
To be fair and representative, we shall create a uniform random sample (URS) of penguins, hence the name.
Every penguin then has the same likelihood of being included in this sample.
So we will see all kinds of unique penguins with all their bells and whistles (and many other gadgets)!

What's the point (besides the cuteness overload)? Actually, this is also an accessible way to visualize uniform random sampling on the Linux kernel (often represented by its penguin mascot [Tux](https://en.wikipedia.org/wiki/Tux_(mascot))), which is still an unsolved problem in software product line engineering.
It is also a useful visual metaphor for other analyses.

So, how to do it?

## The Sane (= Boring) Way

An intuitive, but ultimately doomed-to-fail idea for sampling penguins might be to use Ti*k*Zpingus' integrated `random from` command, for example to create a [grid](images/grid.pdf) of random penguins:

```
\tikz\pingu[random from={{lightsaber left}{shirt}{cloak}{pride flag left}{...}}]
```

Unfortunately, it's very difficult to exclude specific feature interactions this way.
Also, this approach is probably [algebraically incomplete](https://dl.acm.org/doi/abs/10.1145/3689747) because it's basically choice calculus, not option calculus.
Thus, this won't treat every penguin equally, and we can't have that.

## The One and Only Correct Way

We can fix this by ~~overengineering~~ creating a uniform random sample with [bdd4va](https://github.com/rheradio/bdd4va).
As input, we use a penguin feature model manually created in [FeatureIDE](https://featureide.github.io/), which can be manually tweaked to one's liking.
The feature model is based on the [documentation](https://media.githubusercontent.com/media/EagleoutIce/tikzpingus/gh-pages/doc/build/tikzpingus-doc.pdf) of tikzpingurs as of 2025/02/20.

This requires [Java](https://www.java.com/download/) and [Docker](https://docs.docker.com/get-docker/).

```
# first, make any desire changes in penguin.uvl

# to generate a tiny sample, run:
scripts/tikzpingurs.sh

# to specify the emphasize, run:
scripts/tikzpingurs.sh run 100
```

This has been successfully tested on Linux and macOS.
Generating a large sample is cheap (~ seconds), but rendering all the penguins can take a while (~ 2 seconds per penguin).

## License

The source code of this project is released under the [GPL v3 license](LICENSE.txt).