{...}: {
  services.caddy = {
    enable = true;
    enableReload = true;

    openFirewall = true;

    email = "hel" + "lo@u" + "nw.re";
    globalConfig = ''
      admin off # disable admin API
      grace_period 5m # allow killing connections after `5m` when reloading
    '';

    #> handle wildcard by displaying a 404
    # for unconfigured domains.
    virtualHosts.":80, :443" = {
      logFormat = "output discard";
      extraConfig = ''
        respond <<EOF
                ／＞   フ
                |  _  _|
              ／` ミ＿xノ
             /        |
            /   ヽ    ﾉ
            │    | | |
        ／￣|    | | |
        ( ( ヽ＿_ヽ_)__)
        ＼_) we did not find what you were looking for...

        EOF 404
      '';
    };
  };
}
