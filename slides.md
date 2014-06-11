% Python Software Packaging and HashDist
% Aron Ahmadia  
  <aron@ahmadia.net>  
  <http://aron.ahmadia.net>
% 6 May, 2014

## Copy This Lecture!
<br></br>
<p style="text-align: center;">
<a rel="license"
href="http://creativecommons.org/licenses/by/3.0/deed.en_US"><img
alt="Creative Commons License" style="border-width:0"
src="http://mirrors.creativecommons.org/presskit/icons/cc.large.png"
/></a>
<br></br>
<br></br>
<span xmlns:dct="http://purl.org/dc/terms/"
href="http://purl.org/dc/dcmitype/InteractiveResource"
property="dct:title" rel="dct:type">Python Software Packaging and HashDist</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://aron.ahmadia.net" property="cc:attributionName" rel="cc:attributionURL">Aron Ahmadia</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/3.0/deed.en_US">Creative Commons Attribution 3.0 Unported License</a>.
</p>

## Outline

* Review of Packaging Options for Python Developers
* Motivation for HashDist
* HashDist Demo

# Deploying Simple Software Stacks

## Deploying Python Packages (no Extension Modules)

* Create a `setup.py` file with appropriate metadata

```
python setup.py register
python setup.py sdist upload
```

## Deploying Python Packages (no Extension Modules)

A simple install that tracks a Git repository

```
    setup_dict = dict(
        name = 'clawpack',
        maintainer = "Clawpack Developers",
        maintainer_email = "claw-dev@googlegroups.com",
        description = DOCLINES[0],
        long_description = "\n".join(DOCLINES[2:]),
        url = "http://www.clawpack.org",
        download_url = "git+git://github.com/clawpack/clawpack.git#egg=clawpack-dev", 
        license = 'BSD',
        classifiers=[_f for _f in CLASSIFIERS.split('\n') if _f],
        platforms = ["Linux", "Solaris", "Mac OS-X", "Unix"],
        )
```

## Building Python Packages (no Extension Modules)

```
git clone git://github.com/clawpack/clawpack.git
cd clawpack
python setup.py build
```

Or

```
pip install clawpack
```

## Deploying Python Packages with Extension Modules

Building C or Fortran Extension Modules is a bit harder.

* Cython simplifies interfacing C source code.
* NumPy distutils/f2py simplify interfacing Fortran code.

It's tricky to use both in the same setup.py file, but doable.

## Deploying Python Packages that Depend on NumPy Distutils

```
    # egg_info requests only provide install requirements
    # this is how "pip install clawpack" installs numpy correctly.
    if 'egg_info' in sys.argv:
        # not a real install
        from setuptools import setup
        setuptools_dict = dict(
            install_requires = ['numpy >= 1.6',
                                'matplotlib >= 1.0.1',
                                ],                            
            extras_require = {'petclaw': ['petsc4py >= 1.2'],
                              'euler'  : ['scipy >= 0.10.0']},
            )
        setup_dict.update(setuptools_dict)
        setup(**setup_dict)
    else:
        # okay, real install
        setup_package(setup_dict, SUBPACKAGES) 
```

## Deploying Packages on OS X with Homebrew

```
require 'formula'

class Zeromq < Formula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-3.2.4.tar.gz'
  sha1 '08303259f08edd1faeac2e256f5be3899377135e'

  head do
    url 'https://github.com/zeromq/libzmq.git'

    depends_on :automake
    depends_on :libtool
  end


  option :universal
  option 'with-pgm', 'Build with PGM extension'

  depends_on 'pkg-config' => :build
  depends_on 'libpgm' if build.include? 'with-pgm'

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.include? 'with-pgm'
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV['OpenPGM_CFLAGS'] = %x[pkg-config --cflags openpgm-5.2].chomp
      ENV['OpenPGM_LIBS'] = %x[pkg-config --libs openpgm-5.2].chomp
      args << "--with-system-pgm"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To install the zmq gem on 10.6 with the system Ruby on a 64-bit machine,
    you may need to do:

        ARCHFLAGS="-arch x86_64" gem install zmq -- --with-zmq-dir=#{opt_prefix}
    EOS
  end
end
```

## Deploying Packages on RPM-based systems (spec)

```
Name:           ipython
Version:        0.13.1
Release:        5%{?dist}
Summary:        An enhanced interactive Python shell

Group:          Development/Libraries
# See bug #603178 for a quick overview for the choice of licenses
# most files are under BSD and just a few under Python or MIT
# There are some extensions released under GPLv2+
License:        (BSD and MIT and Python) and GPLv2+
URL:            http://ipython.org/
Source0:        http://archive.ipython.org/release/%{version}/%{name}-%{version}.tar.gz
# will be in ipython-0.14
# https://github.com/ipython/ipython/pull/2681
Patch0:         ipython-0.13.1-dont-require-matplotlib.patch

...

%build

%{__python} setup.py build


%install
rm -rf %{buildroot}

%{__python} setup.py install -O1 --skip-build --root %{buildroot}

# ipython installs docs automatically, but in the wrong place
mv %{buildroot}%{_datadir}/doc/%{name} \
    %{buildroot}%{_datadir}/doc/%{name}-%{version}
```

## Deploying Packages using Conda

Conda packages are distributed as binaries, although many are
described by public recipes (and you can add your own).

* meta.yaml (metadata file)
* build.sh (Unix build script which is executed using bash)
* bld.bat (Windows build script which is executed using cmd)
* run_test.py (optional Python test file)
* patches to the source (optional, see below)
* other resources, which are not included in the source and cannot be
generated by the build scripts.

## Deploying Packages using Conda

https://github.com/ContinuumIO/conda-recipes/blob/master/ipython/meta.yaml

```
package:
  name: ipython
  version: 1.0.0rc1

source:
  fn: ipython-1.0.0-rc1.tar.gz
  url: http://archive.ipython.org/testing/1.0.0/ipython-1.0.0-rc1.tar.gz

build:
  entry_points:
    - ipython3 = IPython.terminal.ipapp:launch_new_instance  [py3k]
    - ipython = IPython.terminal.ipapp:launch_new_instance
  osx_is_app: True           [py2k]

requirements:
  build:
    - python
    - setuptools             [win or py3k]
    - pyreadline             [win]
  run:
    - python
    - pyreadline             [win]
    - python.app             [osx and py2k]

test:
  commands:
    - ipython -h
    - ipython3 -h            [py3k]
  imports:
    - IPython

about:
  home: http://ipython.org/
  license: BSD
```

# Deploying Complex Software Stacks with HashDist

*"We are building the car, not reinventing the wheel."*

- Sage Developers

## Deploying Complex Software Stacks

* The typical high-level application sits atop many libraries
* "SciPy Stack"
    - numpy, scipy, matplotlib, ipython, pandas, sympy, nose
* PETSc (typical install):
    - mpi, blas, lapack, hdf5, superlu, umfpack, parmetis

Each of these packages, in turn, frequently depends on underlying
libraries on the system.

## What is a Developer to Do?

* Use a system package manager
    - But then what happens when your users are on a different
      platform or release?
* Use a language package manager
    - But then what whappens when your code relies on multiple
    languages?
* Conda/Anaconda
    - But then how do you integrate, tweak, or build from source?
* **Build it yourself..**

## Homemade Install is Hard

* Visit (15.2K line Bash Script)
* PETSc BuildSystem (31.6K Python Package)
* Dorsal (7.3K Bash Script

## What is HashDist?

* HashDist
    + A user-local tool for developing, managing, versioning, and
    deploying software builds

* HashStack
    + A collection of package specifications for building software using HashDist

## Portability

  There are a number of paths to achieve portability of complex scientific
  software, but there are no magic bullets.  

  Our approach:

  * Source builds using the system's compiler
  * Relocatable, user-local builds
  * Platform- and parameter-driven customization
  * Cygwin for portability on Windows (but any Shell+Python+Git
    will do)
  * Don't rely on the system stack!

##  Sharing and Reuse

  HashDist promotes the sharing of scientific software packages with
  others, and the reuse of other software packages.  

  * Share the recipe for building your software with others
  * Reuse builds from other stacks and profiles on your machine
  * Source and build caches are automatic

## Reproducibility

  When your software stack is built by HashDist, HashDist versions
  your builds like a revision control system.

  * Unique hashes track all components and sub-components of each stack
  * Switching between different versions of the build is a single command
  * Profile and package specifications can be tracked in any
    version control systems
  * Be confident that you can reproduce your code, and that others
    can reproduce it as well.

## Automation

  Installing scientific software shouldn't be harder than entering a
  few command lines.  The following commands install the complete set
  of dependencies for Proteus on any supported system, relying on only
  Python, Git, and a Bash interpreter.

```
ARCH=$(python -c "import sys; print sys.platform")
git clone https://github.com/hashdist/hashdist.git 
git clone https://github.com/hashdist/hashstack2.git stack 
cp stack/examples/proteus.${ARCH}.yaml stack/default.yaml 
cd stack && ../hashdist/bin/hit develop -v -k error -f ../${ARCH}
```

## Flexibility and Extensibility

  By default, HashDist does its best to work everywhere.  As a
  consequence, it relies on the system as little as possible, by default.

  However, HashDist is not dogmatic about dependencies.  It is very easy to
  reuse package dependencies provided by the user from elsewhere on
  the system if desired. 

  Additionally, HashDist encourages the extension and customization of
  builds with a flexible parametrization system.

## Contributors

* Aron Ahmadia
* Ondrej Certik
* Ilya
* Lea Jenkins
* Chris Kees
* Fernando Perez
* Johannes Ring
* Dag Sverre Seljebotn
* Jimmy Tang
* Andy Terrel
