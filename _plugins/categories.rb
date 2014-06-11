module Jekyll
  class Categories < Generator
    def generate (site)
      site.categories.each do |category|
        build_subpages(site, "category", category)
        #generates pages
      end
     end

    def build_subpages(site, type, posts)
      posts[1] = posts[1].sort_by { |p| -p.date.to_f }
      atomize(site, type, posts)
      paginate(site, type, posts)
      #how it will generate sub-pages
    end

    def atomize(site, type, posts)
      path = "/#{type}/#{posts[0]}"
      atom = AtomPage.new(site, site.source, path, type, posts[0], posts[1])
      site.pages << atom
    end
  end

 class AtomPage < Page
   def initialize(site, base, dir, type, val, posts)
     @site = site
     @base = base
     @dir  = dir
     @name = 'atom.xml'

     self.process(@name)
     self.read_yaml(File.join(base, '_layouts'), "group_atom.xml")
     self.data[type] = val
     self.data["grouptype"] = type
     self.data["posts"] = posts[0..9]
    end

  end
end
