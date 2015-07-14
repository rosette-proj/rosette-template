# encoding: UTF-8

require 'boot'
require 'config'

namespace :translations do

  # Auto-generates pig latin translations for test phrases in the demo repo and
  # stores them in the TMS. Should only be used for testing or demo purposes.
  task :import, :repo_name do |t, args|
    repo_name = args[:repo_name] || 'rosette-demo-rails-app'
    rosette_config = RosetteConfig.config
    repo_config = rosette_config.get_repo(repo_name)
    tms = repo_config.tms

    repo_config.repo.each_commit do |commit|
      commit_id = commit.getId.name

      rosette_config.datastore.phrases_by_commit(repo_name, commit_id).each do |phrase|
        repo_config.locales.each do |locale|
          tms.store_translation(
            translate(phrase.key, locale), locale, phrase
          )
        end
      end
    end
  end

  def translate(text, locale)
    case locale.code
      when 'en-PL'
        Pigspeak.translate(text)
      when 'en-LC'
        Lolspeak.translate(text)
    end
  end

end

module Pigspeak
  # the world's quickest and dirtiest pig latin translator
  def self.translate(str)
    str
      .split(/([ .,!?])/)
      .map do |w|
        w.downcase.sub(/\A([^aeiouAEIOU]*)([aeiouAEIOU][^ ,.!?]*)/) do
          "#{$2}#{$1}ay"
        end
      end
      .join
  end
end

# lolcat translator
module Lolspeak
  LOL_REPLACEMENTS = {
    /what/       => %w{wut whut},
    /you\b/      => %w{yu yous yoo u},
    /cture/      => 'kshur',
    /unless/     => 'unles',
    /the\b/      => 'teh',
    /more/       => 'moar',
    /my/         => %w{muh mah},
    /are/        => %w{r is ar},
    /eese/       => 'eez',
    /ph/         => 'f',
    /as\b/       => 'az',
    /seriously/  => 'srsly',
    /er\b/       => 'r',
    /sion/       => 'shun',
    /just/       => 'jus',
    /ose\b/      => 'oze',
    /eady/       => 'eddy',
    /ome?\b/     => 'um',
    /of\b/       => %w{of ov of},
    /uestion/    => 'wesjun',
    /want/       => 'wants',
    /ead\b/      => 'edd',
    /ucke/       => %w{ukki ukke},
    /sion/       => 'shun',
    /eak/        => 'ekk',
    /age/        => 'uj',
    /like/       => %w{likes liek},
    /love/       => %w{loves lub lubs luv},
    /\bis\b/     => ['ar teh','ar'],
    /nd\b/       => 'n',
    /who/        => 'hoo',
    /'/          => %q{},
    /ese\b/      => 'eez',
    /outh/       => 'owf',
    /scio/       => 'shu',
    /esque/      => 'esk',
    /ture/       => 'chur',
    /\btoo?\b/   => %w{to t 2 to t},
    /tious/      => 'shus',
    /sure\b/     => 'shur',
    /tty\b/      => 'tteh',
    /were/       => 'was',
    /ok\b/       => %w{'k kay},
    /\ba\b/      => %q{},
    /ym/         => 'im',
    /thy\b/      => 'fee',
    /\wly\w/     => 'li',
    /que\w/      => 'kwe',
    /oth/        => 'udd',
    /ease/       => 'eez',
    /ing\b/      => %w{in ins ng ing},
    /have/       => ['has', 'hav', 'haz a'],
    /your/       => %w{yur ur yore yoar},
    /ove\b/      => %w{oov ove uuv uv oove},
    /for/        => %w{for 4 fr fur for foar},
    /thank/      => %w{fank tank thx thnx},
    /good/       => %w{gud goed guud gude gewd},
    /really/     => %w{rly rily rilly rilley},
    /world/      => %w{wurrld whirld wurld wrld},
    /i'?m\b/     => 'im',
    /(?!e)ight/  => 'ite',
    /(?!ues)tion/      => 'shun',
    /you'?re/          => %w{yore yr},
    /\boh\b(?!.*hai)/  => %w{o ohs},
    /can\si\s(?:ple(?:a|e)(?:s|z)e?)?\s?have\sa/ => 'i can has',
    /(?:hello|\bhi\b|\bhey\b|howdy|\byo\b),?/    => 'oh hai,',
    /(?:god|allah|buddah?|diety)/                => 'ceiling cat',
  }

  def self.translate(phrase, add_ending = true)
    phrase.downcase!

    LOL_REPLACEMENTS.each_pair do |english_snippet, lol_snippet|
      phrase.gsub!(english_snippet) do |match|
        lol_snippet.is_a?(Array) ? lol_snippet.sample : lol_snippet
      end
    end

    phrase.gsub!(/\s{2,}/, ' ')
    phrase.gsub!(/teh teh/, 'teh') # meh, it happens sometimes.
    phrase << '.  kthxbye!' if rand(10) == 2 && add_ending
    phrase << '.  kthx.'    if rand(10) == 1 && add_ending
    phrase.gsub!(/(\?|!|,|\.)\./, '\1')

    phrase.upcase
  end
end
