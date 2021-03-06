import Foundation
import SwiftyJSON

struct Anime {
    public private(set) var id: Int
    public private(set) var series_type: String
    public private(set) var title_romaji: String
    public private(set) var title_english: String
    public private(set) var title_japanese: String
    public private(set) var type: String
    public private(set) var start_date: String
    public private(set) var end_date: String
    public private(set) var start_date_fuzzy: Int
    public private(set) var end_date_fuzzy: Int
    public private(set) var season: Int
    public private(set) var description: String
    public private(set) var synonyms: [JSON]
    public private(set) var genres: String
    public private(set) var adult: Bool
    public private(set) var average_score: Double
    public private(set) var popularity: Int
    public private(set) var favourite: Bool
    public private(set) var image_url_sml: String
    public private(set) var image_url_med: String
    public private(set) var image_url_lge: String
    public private(set) var image_url_banner: String
    public private(set) var updated_at: Int
    public private(set) var total_episodes: Int
    public private(set) var duration: Int
    public private(set) var airing_status: String
    public private(set) var youtube_id: String
    public private(set) var hashtag: String
    public private(set) var source: String
    public private(set) var tags: String
    public private(set) var airing: Airing
    public private(set) var characters: [CharacterStaff];
    public private(set) var staffs: [CharacterStaff];
    public private(set) var studio: String
    public private(set) var external_links: [ExternalLink]
    
    init(anime: JSON) {
        self.id = anime["id"].intValue
        self.series_type = anime["series_type"].stringValue
        self.title_romaji = anime["title_romaji"].stringValue
        self.title_english = anime["title_english"].stringValue
        self.title_japanese = anime["title_japanese"].stringValue
        self.type = anime["type"].stringValue
        self.start_date = anime["start_date"].stringValue
        self.end_date = anime["end_date"].stringValue
        self.start_date_fuzzy = anime["start_date_fuzzy"].intValue
        self.end_date_fuzzy = anime["end_date_fuzzy"].intValue
        self.season = anime["season"].intValue
        self.description = anime["description"].stringValue
        self.synonyms = anime["synonyms"].arrayValue
        self.adult = anime["adult"].boolValue
        self.average_score = anime["average_score"].doubleValue
        self.popularity = anime["popularity"].intValue
        self.favourite = anime["favourite"].boolValue
        self.image_url_sml = anime["image_url_sml"].stringValue
        self.image_url_med = anime["image_url_med"].stringValue
        self.image_url_lge = anime["image_url_lge"].stringValue
        self.image_url_banner = anime["image_url_banner"].stringValue
        self.updated_at = anime["updated_at"].intValue
        self.total_episodes = anime["total_episodes"].intValue
        self.duration = anime["duration"].intValue
        self.airing_status = anime["airing_status"].stringValue
        self.youtube_id = anime["youtube_id"].stringValue
        self.hashtag = anime["hashtag"].stringValue
        self.source = anime["source"].stringValue
        self.airing = Airing(airingJSON: anime["airing"])
        
        // set external links
        self.external_links = []
        for link in anime["external_links"].arrayValue {
            let externalLink = ExternalLink(exLink: link)
            self.external_links.append(externalLink)
        }
        
        // set tags
        var tagsArray = [String]()
        for tags in anime["tags"].arrayValue {
            tagsArray.append(tags["name"].stringValue)
        }
        self.tags = tagsArray != [] ? tagsArray.joined(separator: ", ") : "N/A"
        
        // set genres
        var genresArray = [String]()
        for gen in anime["genres"].arrayValue {
            genresArray.append(gen.stringValue)
        }
        self.genres = genresArray != [] ? genresArray.joined(separator: ", ") : "N/A"
        
        // set main studio
        var studioArray = [String]()
        for stu in anime["studio"].arrayValue {
            studioArray.append(stu["studio_name"].stringValue)
        }
        self.studio = studioArray != [] ? studioArray.joined(separator: ", ") : "N/A"
        
        // set characters
        self.characters = []
        for char in anime["characters"].arrayValue {
            let character = CharacterStaff(charJSON: char)
            self.characters.append(character)
        }
        
        // set staffs
        self.staffs = []
        for staff in anime["staff"].arrayValue {
            let staff = CharacterStaff(charJSON: staff)
            self.staffs.append(staff)
        }
    }
    
}
