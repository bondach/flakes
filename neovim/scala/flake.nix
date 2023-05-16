{
  description = "A basic neovim flake for scala";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    base = {
     url = "github:bondach/flakes?dir=neovim/base";
     inputs.nixpkgs.follows     = "nixpkgs";
     inputs.flake-utils.follows = "flake-utils";
    };
    np-metals = {
      url = "github:scalameta/nvim-metals";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, base, ... }:
    let
      cfg      = import ./config;
      buildIDE = { system, jdk, metalsVersion ? "0.11.12" }: 
        let
          javaO    = final: prev: {
            jdk = jdk;
            jre = jdk;
          };
          pkgs     = import nixpkgs { inherit system; overlays = [ javaO ]; };
          metals   =
            let
              outputHash = if (metalsVersion == "0.11.12") then "sha256-3zYjjrd3Hc2T4vwnajiAMNfTDUprKJZnZp2waRLQjI4="
                           else if (metalsVersion == "0.11.11") then "sha256-oz4lrRnpVzc9kN+iJv+mtV/S1wdMKwJBkKpvmWCSwE0="
                           else "undefined";
              metalsDeps = pkgs.stdenv.mkDerivation {
                name = "metals-${metalsVersion}";
                buildCommand = ''
                  export COURSIER_CACHE=$(pwd)
                  ${pkgs.coursier}/bin/cs fetch org.scalameta:metals_2.13:${metalsVersion} \
                    -r bintray:scalacenter/releases \
                    -r sonatype:snapshots > deps
                  mkdir -p $out/share/java
                  cp -n $(< deps) $out/share/java
                '';
                outputHashMode = "recursive";
                outputHashAlgo = "sha256";
                inherit outputHash;
              };
            in pkgs.metals.overrideAttrs (old: {
              version = metalsVersion;
              extraJavaOpts = old.extraJavaOpts + " -Dmetals.client=nvim-lsp";
              buildInputs   = [ metalsDeps ];
            });
          tools   = base.tools { inherit pkgs; };
        in base.buildNeovim {
          inherit system;
          additionalConfig      = cfg.buildConfig    { inherit metals; jdk = pkgs.jdk; };
          additionalPlugins     = tools.buildPlugins { inherit inputs; postPatchHack = _: ""; };
          additionalRuntimeDeps = [ metals pkgs.sbt pkgs.jdk pkgs.coursier ];
        };
    in
      flake-utils.lib.eachDefaultSystem(system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          packages = {
            default = buildIDE { inherit system; jdk = pkgs.graalvm19-ce; };
          };
        }) // {
          buildIDE = buildIDE;
        };
}
