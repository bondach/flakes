{
  description = "A basic flake for neovim";

  outputs = inputs@{ self, nixpkgs, flake-utils, neovim, ... }: let
    toolsPredef = import ./tools;
    config      = import ./config;
    buildNeovim = { system, additionalConfig ? "", additionalPlugins ? [ ], additionalRuntimeDeps ? [] }:
      let
        pkgs    = import nixpkgs { inherit system; };
        tools   = toolsPredef { inherit pkgs; };
        plugins =
          let
            postPatchHack = name:
              if (name == "treesitter") then ''
                rm -r parser
                ln -s ${treesitterGrammars} parser
              '' else "";
            treesitterGrammars = pkgs.tree-sitter.withPlugins(p: [
              (pkgs.tree-sitter.buildGrammar {
                language = "scala";
                version  = inputs.ts-g-scala.rev;
                src      = inputs.ts-g-scala;
              })
              (pkgs.tree-sitter.buildGrammar {
                language = "java";
                version  = inputs.ts-g-java.rev;
                src      = inputs.ts-g-java;
              })
              (pkgs.tree-sitter.buildGrammar {
                language = "hocon";
                version  = inputs.ts-g-hocon.rev;
                src      = inputs.ts-g-hocon;
              })
              (pkgs.tree-sitter.buildGrammar {
                language = "proto";
                version  = inputs.ts-g-proto.rev;
                src      = inputs.ts-g-proto;
              })
              (pkgs.tree-sitter.buildGrammar {
                language = "bash";
                version  = inputs.ts-g-bash.rev;
                src      = inputs.ts-g-bash;
              })
              # Грамматика не билдится
              #(pkgs.tree-sitter.buildGrammar {
              #  language = "sql";
              #  version  = inputs.ts-g-sql.rev;
              #  src      = inputs.ts-g-sql;
              #})
              p.tree-sitter-lua
              p.tree-sitter-fish
              p.tree-sitter-clojure
              p.tree-sitter-markdown
              p.tree-sitter-markdown-inline
              p.tree-sitter-json
              p.tree-sitter-nix
              p.tree-sitter-yaml
              p.tree-sitter-query
              p.tree-sitter-regex
              p.tree-sitter-rust
            ]);
        in tools.buildPlugins {
            inherit inputs postPatchHack;
        };
        neovim = pkgs.wrapNeovim inputs.neovim.packages.${system}.neovim {
          viAlias = true;
          vimAlias = true;
          configure = {
            customRC = ''
              lua << EOF
              ${config}
              ${additionalConfig}
              EOF
            '';
            packages.myVimPackage = {
              start = plugins ++ additionalPlugins;
              opt   = [];
            };
          };
        }; 
      in pkgs.symlinkJoin {
        name = "neovim";
        paths = [ neovim pkgs.ripgrep pkgs.fd ] ++ additionalRuntimeDeps;
      };
  in
    flake-utils.lib.eachDefaultSystem(system: {
      packages = {
        default = buildNeovim { inherit system; };
      };
    }) // {
      buildNeovim = buildNeovim;
      tools       = toolsPredef;
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      # Тащим неовим версии 0.9.1
      url = "github:neovim/neovim?dir=contrib&rev=7d4bba7aa7a4a3444919ea7a3804094c290395ef";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    np-plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    np-telescope = {
      url = "github:nvim-telescope/telescope.nvim?ref=0.1.x";
      flake = false;
    };
    np-kanagawa = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };
    np-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    np-lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    np-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    np-which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    np-nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    np-neo-tree = {
      url = "github:nvim-neo-tree/neo-tree.nvim?ref=v2.x";
      flake = false;
    };
    np-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    ts-g-scala = {
      url = "github:tree-sitter/tree-sitter-scala";
      flake = false;
    };
    ts-g-java = {
      url = "github:tree-sitter/tree-sitter-java";
      flake = false;
    };
    ts-g-hocon = {
      url = "github:antosha417/tree-sitter-hocon";
      flake = false;
    };
    ts-g-proto = {
      url = "github:mitchellh/tree-sitter-proto";
      flake = false;
    };
    ts-g-bash = {
      url = "github:tree-sitter/tree-sitter-bash";
      flake = false;
    };
    ts-g-sql = {
      url = "github:derekstride/tree-sitter-sql";
      flake = false;
    };
    np-promise-async = {
      url   = "github:kevinhwang91/promise-async";
      flake = false;
    };
    np-ufo = {
      url = "github:kevinhwang91/nvim-ufo";
      flake = false;
    };
    np-statuscol = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };
    np-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    np-lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    np-cmp-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    np-cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    np-vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };
    np-nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    np-cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    np-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    np-cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    np-cmp-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };
  };

}
