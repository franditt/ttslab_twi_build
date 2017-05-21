=========================================
How to build a slot-and-filler TTS system
=========================================

1. Introduction
===============

This document describes the process of building a simple
slot-and-filler TTS system from the current resource using *TTSLab*
and *TTSLabdev* tools. This is done by automatically processing the
audio resources available here to create an audio database of words
that are then used to synthesise sentences with varying content.

In the following section present an overview of the process to
building a slot-and-filler system, focussing on aspects of building
the system once suitable recordings have been done. This is followed
by more detailed sections describing how to install te required
software and construct a system given the current resources.


2. Developing a new system
==========================

The following developmental steps are briefly discussed in this
section:

1. Design and recording of a suitable script.
2. Development of basic text parsing and normalisation modules.
3. Development of basic pronunciation resources.
4. Processing of audio data to construct a unit-selection database.

This is followed by a detailed description of how to install the
required software, setup resources, execute development scripts and
test the resulting system in Section 3 and Section 4.


2.1 Designing and recording the script
--------------------------------------

Given a specific target application, a set of sentences should be
designed so that all the basic sentences to be used are contained in
the script. Where content will vary, e.g. slots for changing dates,
numbers and other variable content, all variations should also be
included. It is preferable that these be embedded in sentences in the
script for recording in order to preserve the prosodic features of the
utterances.

As far as possible, the recording conditions should be kept constant
(doing recordings in a single session is beneficial if
possible). Recording the sentences at a comfortable tempo (i.e. not
too fast) also eases the process of processing the speech
automatically and can be beneficial to the system's overall
intelligibility.

See Section ??? for formatting of the script and audio recordings for
further processing.


2.2 Development of basic text processing modules
------------------------------------------------

In order to process recorded audio and perform synthesis, input text
needs to be *normalised*, i.e. converted into text where all
tokens/words are spelled out in the standard orthography of the
language, and *tokenised*, i.e. split into seperate words.

*TTSLab* has default methods for tokenisation and simple
normalisation, however it is usually necessary to write custom modules
to do at least digit and date expansions depending on the nature of
input text.


2.3 Development of basic pronunciation resources
------------------------------------------------

For automatic alignment of audio recordings with the script, it is
necessary to define a *phone set* (set of sounds) for the language as
well as a set of rules for conversion from letters (or *graphemes*) in
the orthography to *phones*. Alternatively a pronunciation dictionary
can be constructed for all words contained in the script, or if the
orthography is very regular with respect to pronunciation, the
*graphemes* may be used to represent *phones* directly.

See Section ??? for an example of the definition of these resources in
*TTSLab*.


2.4 Processing of audio data to construct a unit-selection database
-------------------------------------------------------------------

In order to construct a unit-selection database, all resources
described above need to be completed and suitably setup in order to
perform the following three steps:

1. Automatic phone alignment based on the orthographic transcriptions,
   audio files and pronunciation resources.
2. Feature extraction.
3. Speech segmentation and database creation.

This process is described in Section 4.


3. Software setup
=================

3.1. External dependencies
--------------------------

In order to build this system a GNU/Linux system with various speech
processing utilities is required. Before continuing please ensure that
the following are installed.

The following software can easily be installed from your Linux
distribution's software repository and should be on your system path:

- Python 2.7 or higher
- Numpy
- Scipy
- SoX
- normalize-audio (http://normalize.nongnu.org/)
- Praat (http://www.fon.hum.uva.nl/praat/)

In addition, the following software should be downloaded from the
given locations and built appropriately. There is no need to install
these to your system, further information will be provided where paths
to these packages can be configured:

- HTK 3.4.1 (http://htk.eng.cam.ac.uk/)
- Edinburgh Speech Tools 2.1
(http://www.cstr.ed.ac.uk/downloads/festival/2.1/speech_tools-2.1-release.tar.gz)


3.2. Setting up TTSLab and TTSLabdev
------------------------------------

Clone or download the *ttslab* and *ttslabdev* repositories from
https://github.com/demitasse/ttslab and
https://github.com/demitasse/ttslabdev respectively.

We will refer to the directories where these are located as
``TTSLAB_ROOT`` and ``TTSLABDEV_ROOT``.

Add the following paths to your ``PYTHONPATH``: ``$TTSLAB_ROOT`` and
``$TTSLABDEV_ROOT/modules``. This can be done by including the
following line in your ``.bashrc`` file::

  export PYTHONPATH=$TTSLABDEV_ROOT/modules:$TTSLAB_ROOT:$PYTHONPATH

Add the following path to your ``PATH``:
``$TTSLABDEV_ROOT/scripts``. This can be done by including the
following in your ``.bashrc`` file::

  export PATH=$TTSLABDEV_ROOT/scripts:$PATH


4. Building and testing a system
================================

4.1 Setting up basic resources
------------------------------

Before the current resources may be used, one file needs to be
developed for the language describing the *phone set* and included in
*TTSLab*. For Bambara this file has been completed and is located at
``TTSLAB_ROOT/ttslab/voices/bambara_default.py``.

Next, the current repository can be extracted to ``$BAMBARA_BUILD``
and should have the following contents (simplified to only show files
relevant to the current discussion)::

  .
  |-- do_alignments.sh
  |-- do_us_catalogue.sh
  |-- setup_alignments.sh
  |-- paths.sh
  |-- etc
  |   |-- broad_category_mapping.txt
  |   |-- feats.conf
  |   `-- utts.data -> ../recordings/chunked/utts.data
  |-- recordings
  |   `-- chunked
  |       |-- utts.data
  |       `-- wavs
  `-- ttslab
      |-- data
      |   |-- pronun
      |   |   |-- addendum.dict
      |   |   `-- main.rules
      |   `-- unitcatalogue.pickle -> ../../build/unitcatalogue.pickle
      `-- make.sh


4.1.1 Compiling text-processing front-end
+++++++++++++++++++++++++++++++++++++++++

If *TTSLab* and *TTSLabdev* are setup correctly as described above,
this first thing that needs to be done is to compile the pronunciation
resources and create a *voice definition* for the language. This can
be done here by running ``make.sh`` in ``$BAMBARA_BUILD/ttslab``. The
resulting subtree should look like this::

  .
  |-- data
  |   `-- pronun
  |       |-- addendum.dict
  |       `-- main.rules
  |-- frontend.voice.pickle
  |-- frontend.wordus.voice.pickle
  |-- g2p.pickle
  |-- make.sh
  |-- phoneset.pickle
  |-- pronunaddendum.pickle
  `-- pronundict.pickle

This has taken the definition in
``TTSLAB_ROOT/ttslab/voices/bambara_default.py`` and the simple
pronunciation dictionary and letter to sound rules in
``BAMBARA_BUILD/ttslab/data/pronun`` and compiled a voice definition
``BAMBARA_BUILD/ttslab/frontend.wordus.voice.pickle``.

The format of ``addendum.dict`` is one entry per line starting with
the word (lower cased) followed by whitespace seperated list of
phones. ``main.rules`` contains hand-written rewrite rules where a
single field per line has the form::

 grapheme;leftcontext;rightcontext;phoneme;ordinal;statistic

Empty fields denote any context and rules are ordered from most to
least general. The ``statistic`` field is not important here.


4.1.2 Configuration for speech processing
+++++++++++++++++++++++++++++++++++++++++

In order to perform automatic alignment and construction of the speech
database, the following needs to be set:

- Paths to HTK and Edinburgh Speech Tools binaries can be set in
  ``paths.sh``
- Each phone in the language's *phone set* needs to be mapped roughly
  to a broad phonetic category to improve alignment accuracy. This is
  specified in ``broad_category_mapping.txt``. Category descriptions
  are listed below.
- The speaker's pitch range needs to be set in ``feats.conf`` (only
  the ``MIN`` and ``MAX`` fields need to be specified).

Supported phonetic categories are:

- ``cau`` and ``cav``, unvoiced and voiced *affricates* respectively.
- ``cfu`` and ``cfv``, unvoiced and voiced *fricatives*.
- ``cpu`` and ``cpv``, unvoiced and voiced *plosives*.
- ``cnv``, *nasals*.
- ``cxv``, *approximants*.
- ``vlv`` and ``vsv``, long and short *vowels*.
- ``vdv``, *diphthongs*.
- ``psu`` and ``plu``, short (also used for plosive closures) and long *silences*.


4.1.3 Setting up recordings for alignment
+++++++++++++++++++++++++++++++++++++++++

The directory ``BAMBARA_BUILD/recordings/chunked`` contains a ``wavs``
directory containing an audio file (with basename matching) for every
entry in ``utts.data``. Audio files need to be in RIFF Wave format
(any bitrate and samplerate) and ``utts.data`` in UTF-8 text.

If this has been setup, ``setup_alignments.sh`` can be run from the
``$BAMBARA_BUILD`` root directory (all these shell scripts need to be
run from this directory) as follows::

 ./setup_alignments.sh

This should create a ``build`` directory and process the audio files
appropriately (downsampling and energy normalisation) and copy the
``etc`` configuration directory for this build.


4.1.4 Phone alignment and system creation
+++++++++++++++++++++++++++++++++++++++++

Once a ``build`` directory is constructed, the alignment process can
be done (a full path to the voice frontend file is required)::

 ./do_alignments.sh $PWD/ttslab/frontend.wordus.voice.pickle

This should add the following subdirectories in ``build``: ``halign``,
``textgrids`` and ``utts``. Alignments can be verified by viewing
textgrid files in Praat. If acceptable, feature extraction for the
database can be done::

 ./do_us_catalogue.sh $PWD/ttslab/frontend.wordus.voice.pickle feats

followed by compilation of the database::

 ./do_us_catalogue.sh $PWD/ttslab/frontend.wordus.voice.pickle catalogue

which should result in the file ``unitcatalogue.pickle`` being created
in ``build``. This file should have a symbolic link in ``ttslab/data``
allowing the following to be executed in the ``ttslab`` directory::

 ttslab_make_voice.py wordus

resulting in the file ``ttslab/wordus.voice.pickle``. Which can be
loaded and tested from within a Python interpreter as follows (we use
the word "banbara" as test input text here)::

 import ttslab
 voice = ttslab.fromfile("wordus.voice.pickle")
 utt = voice.synthesize("banbara", "text-to-wave")
 utt["waveform"].write("test.wav")

which should result in an audio file ``test.wav`` containing
synthesized speech for the word "banbara".

