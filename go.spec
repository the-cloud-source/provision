%define go_root /usr/local/go
%define package_version 1.3
%define package_release 1

%define debug_package %{nil}

%define __find_provides         %{nil}
%define __find_requires         %{nil}
%define __os_install_post       %{nil}
%define _use_internal_dependency_generator 0

%define vim_syntax /usr/share/vim/vim70/syntax/

Name: 		go
Version: 	%{package_version}
Release: 	%{package_release}%{dist}
Summary: 	go language
Group:		Software
Packager:	João Fontes <Joao.Fontes@Blip.pt>
License: 	MIT
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot-%(%{__id_u} -n)
Source:		https://storage.googleapis.com/golang/go%{version}.linux-amd64.tar.gz
#SHA1:		b6b154933039987056ac307e20c25fa508a06ba6

%description
The Go Language

%package doc
Summary: Go docs
Group:   Software
%description doc
Go docs.

%package test
Summary: Go tests
Group:   Software
%description test
Go tests.

%prep
%{!?dist:%{error: dist is not defined!}}
[ "$UID" == "0" ] && echo "ERROR: Can't build as root (uid=$UID)" && exit 1

%build
%{!?dist:%{error: dist is not defined!}}
[ "$UID" == "0" ] && echo "ERROR: Can't build as root (uid=$UID)" && exit 1

%install
echo "****" $PWD "****"
rm -rf ${RPM_BUILD_ROOT:?}
mkdir -p ${RPM_BUILD_ROOT:?}/%{go_root}
(cd ${RPM_BUILD_ROOT:?}/%{go_root} && cd .. && tar xf %{SOURCE0})

mkdir -p ${RPM_BUILD_ROOT:?}/etc/profile.d
echo 'export GOROOT=%{go_root}'         > ${RPM_BUILD_ROOT:?}/etc/profile.d/go.sh
echo 'export PATH=$PATH:${GOROOT}/bin' >> ${RPM_BUILD_ROOT:?}/etc/profile.d/go.sh

mkdir -p ${RPM_BUILD_ROOT:?}/%{vim_syntax}
(cd ${RPM_BUILD_ROOT:?}/%{vim_syntax} && ln -s %{go_root}/misc/vim/syntax/go.vim    go.vim)
(cd ${RPM_BUILD_ROOT:?}/%{vim_syntax} && ln -s %{go_root}/misc/vim/syntax/godoc.vim godoc.vim)

exit 0

%clean
%{!?dist:%{error: dist is not defined!}}
[ "$UID" == "0" ] && echo "ERROR: Can't build as root (uid=$UID)" && exit 1
rm -rf ${RPM_BUILD_ROOT:?}
rm -rf ${RPM_BUILD_DIR:?}/go

%pre

%post 
(cd %{vim_syntax} && ln -s %{go_root}/misc/vim/syntax/go.vim    go.vim)    2>/dev/null || :
(cd %{vim_syntax} && ln -s %{go_root}/misc/vim/syntax/godoc.vim godoc.vim) 2>/dev/null || :
: || : || : || : || : || : || :

%files
%attr(-,    root, root)         %{go_root}/README
%attr(-,    root, root)         %{go_root}/VERSION
%attr(0755, root, root)    %dir %{go_root}
%attr(-,    root, root)         %{go_root}/api
%attr(-,    root, root)         %{go_root}/bin
%attr(-,    root, root)         %{go_root}/include
%attr(-,    root, root)         %{go_root}/lib
%attr(-,    root, root)         %{go_root}/misc
%attr(-,    root, root)         %{go_root}/pkg
%attr(-,    root, root)         %{go_root}/src

%ghost                          %{vim_syntax}/go.vim
%ghost                          %{vim_syntax}/godoc.vim

%attr(0755, root, root)         /etc/profile.d/go.sh

%files test
%attr(-,    root, root)         %{go_root}/test

%files doc
%attr(-,    root, root)         %{go_root}/blog
%attr(-,    root, root)         %{go_root}/doc
%attr(-,    root, root)         %{go_root}/robots.txt
%attr(-,    root, root)         %{go_root}/favicon.ico
%attr(-,    root, root)         %{go_root}/AUTHORS
%attr(-,    root, root)         %{go_root}/CONTRIBUTORS
%attr(-,    root, root)         %{go_root}/LICENSE
%attr(-,    root, root)         %{go_root}/PATENTS


%changelog
* Fri Oct 24 2014 João Fontes <Joao.Fontes@Blip.pt> - 1
- built for 1.3
