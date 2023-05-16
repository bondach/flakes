{ pkgs }: {
  buildPlugins = import ./buildPlugins.nix { inherit pkgs; };
}
