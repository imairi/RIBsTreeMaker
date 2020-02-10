<img src="https://img.shields.io/github/license/imairi/RIBsTreeMaker.svg">

# RIBsTreeMaker

<p align="center">
  <img src="https://raw.githubusercontent.com/imairi/RIBsTreeMaker/master/images/logo.png" width="500">
</p>

RIBsTreeMaker visualize [RIBs](https://github.com/uber/RIBs) business logic tree. The output style is org-mode mindmap.

## Usage
```
swift run RIBsTreeMaker [path/to/iOSproject] --under [RIB name]
```

Use `under` option, the tree will be displayed only under the RIB.

## Vesualize for mindmap
The output style is org-mode mindmap. For example, if use PlantUML the RIBs tree is visualized like the below.

```uml
@startmindmap
* Root
** LoggedOut
*** TermsOfUse
**** FailedLoading
*** Welcome
**** SignInFailedDialog
**** ForgotPassword
***** IdentityVerification
****** SMSAuthentication
******* ResetPassword
** LoggedIn
@endmindmap
```

<p align="center">
  <img src="https://raw.githubusercontent.com/imairi/RIBsTreeMaker/master/images/example_tree.png" width="800">
</p>
