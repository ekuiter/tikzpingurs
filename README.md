# Ti*k*ZpingURS

[![made-with-latex](https://img.shields.io/badge/Made%20with-LaTeX-1f425f.svg)](https://www.latex-project.org/) [![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/GPL-3.0)

Clearly, we should be able to show off the diversity of (cute) little penguins that can be typeset with [Ti*k*Zpingus](https://github.com/EagleoutIce/tikzpingus).

But we cannot highlight every penguin in (potential) existence, as there are simply too many.
To be fair and representative, we shall create a uniform random sample (URS) of penguins, hence the name.
Every penguin has the same likelihood of being included in this sample.
So we will see all kinds of unique penguins with all their bells and whistles (and many other gadgets)!

What's the point (besides the cuteness overload)? Actually, this is also an accessible metaphor for uniform random sampling on the Linux kernel (often represented by its penguin mascot [Tux](https://en.wikipedia.org/wiki/Tux_(mascot))), which is still an unsolved problem in software product line engineering.

So, how to do it?

## The Sane (= Boring) Way

An intuitive, but ultimately doomed-to-fail idea for sampling penguins might be to use Ti*k*Zpingus' integrated `random from` command, for example to create a [grid](tex/grid.pdf) of random penguins:

```
\tikz\pingu[random from={{lightsaber left}{shirt}{cloak}{horse left}{laptop left}{staff left}{pride flag left}}]
```

Unfortunately, this won't treat every penguin equally, and we can't have that.
Also, it's very difficult to exclude specific feature interactions this way.
This kind of specification may even be [algebraically incomplete](https://dl.acm.org/doi/abs/10.1145/3689747) because it's basically choice calculus, not option calculus.

## The One and Only Correct Way

Let's fix this by ~~overengineering~~ creating a uniform random sample with [bdd4va](https://github.com/rheradio/bdd4va).
As input, we use a penguin feature model created in [FeatureIDE](https://featureide.github.io/), which can be manually tweaked to one's liking.

This requires [Docker](https://docs.docker.com/get-docker/) on an `x86_64` Linux system.

```
# step 0 (optional): use FeatureIDE to adjust penguin.uvl
# then re-export it as penguin.xml (SXFM) and run:
sed -i 's/(.*$//' penguin.xml

# step 1: generate a uniform random sample of penguin configurations
export N=10
docker build . -t tikzpingurs
docker run --rm tikzpingurs $N | grep -v \\.$ > sample.txt

# step 2: draw all the penguins in the sample into the pingus/ directory
./draw_penguins.sh
```

## License

The source code of this project is released under the [GPL v3 license](LICENSE.txt).