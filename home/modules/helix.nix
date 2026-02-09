{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      #copilot-language-server
      basedpyright             # Python 静态检查
      ruff                     # 极速格式化
    ];

    settings = {
      theme = "noctalia";
      editor = {
        inline-diagnostics = { cursor-line = "hint"; };

        preview-completion-insert = true;  # 行内预览
        #completion-trigger-len = 1;
        #idle-timeout = 50;
      };
    };

    languages = {
      language = [
        {
          name = "python";
          language-servers = [ "basedpyright" "ruff"]; #"copilot" ];
          auto-format = true;
        }
      ];

      #language-server = {
      #  copilot = {
      #    command = "copilot-language-server";
      #    args = [ "--stdio" ];
      #    config = {
      #      editorInfo = { name = "Helix"; version = "25.07.01"; };
      #      serverOptions = { "inlineCompletions" = true; };
      #    };
      #  };
      #};
    };
  };
}
