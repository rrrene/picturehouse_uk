module PicturehouseUk

  # Internal utility classes: Do not use
  # @api private
  module Internal

    # Parses a chunk of HTML to derive movie showing data
    class FilmWithScreeningsParser

      # @param [String] film_html a chunk of html
      def initialize(film_html)
        @nokogiri_html = Nokogiri::HTML(film_html)
      end

      # The film name
      # @return [String]
      def film_name
        name = @nokogiri_html.css('.movielink').children.first.to_s

        # screening types
        name = name.gsub /\s\[(AS LIVE: )?[ACPGU1258]+\]/, '' # remove certificate
        name = name.gsub /\s\[NO CERT\]/, '' # remove no certificate
        name = name.gsub /\s\[\]/, '' # remove no certificate
        name = name.gsub /\s+[23][dD]/, '' # remove 2d or 3d from title

        # special screenings
        name = name.gsub 'ROH. Live:', 'Royal Opera House:' # fill out Royal Opera House
        name = name.gsub 'Met. Encore:', 'Met Opera:' # fill out Met Opera
        name = name.gsub 'NT Encore:', 'National Theatre:' # National theatre
        name = name.gsub 'RSC Live:', 'Royal Shakespeare Company:' # RSC
        name = name.gsub 'RSC Encore:', 'Royal Shakespeare Company:' # RSC

        name = name.squeeze(' ') # spaces compressed
        name = name.gsub /\A\s+/, '' # remove leading spaces
        name = name.gsub /\s+\z/, '' # remove trailing spaces
      end

      # Showings
      # @return [Hash]
      # @example
      #   {
      #     "2D" => [Time.utc, Time.utc]
      #   }
      def showings
        @nokogiri_html.css('a[epoch]').inject({}) do |result, link|
          key = case link['class']
            when /big_scream/ then 'baby'
            when /kids_club|toddler_time/ then 'kids'
            when /silver_screen/ then 'silver'
            when /subtitled_cinema/ then 'subtitled'
            else '2d'
          end
          # this is a hack because Time.at() only uses local time
          time = Time.utc(1970)+link['epoch'].to_i

          result.merge(key => (result[key] || []) << time)
        end
      end
    end
  end
end
