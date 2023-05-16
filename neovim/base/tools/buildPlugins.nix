{ pkgs }:
{ inputs, postPatchHack}:
  let
    prefix = "np-";
    inherit (builtins) match substring stringLength filter map attrNames;
    isPlugin      = str: (match "${prefix}.*" str) != null;
    getPrettyName = str: substring (stringLength prefix) (stringLength str) str;
    names         = filter isPlugin (attrNames inputs);
    buildFunc     = name:
      pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname     = getPrettyName name;
        version   = inputs.${name}.rev;
        src       = inputs.${name};
        postPatch = postPatchHack (getPrettyName name);
      };
  in map buildFunc names
