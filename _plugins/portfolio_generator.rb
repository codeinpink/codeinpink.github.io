module Jekyll
    class ProjectPage < Page
        def initialize(site, base, dir, project_data)
            @site = site
            @base = base
            @dir = dir
            @name = "index.html"

            self.process(@name)
            self.read_yaml(File.join(base, "_layouts"), "project.html")

            project_data.each { |key, value| self.data[key] = value }
        end
    end

    class PortfolioGenerator < Generator
        def generate(site)
            dir = site.config["portfolio_dir"] || "portfolio"

            # First get the related projects and add them to each project
            compute_related_projects(site)

            # Then generate the project pages
            site.data["projects"].each do |project_file|
                project = project_file[1]

                # I Love Cats -> i-love-cats
                file_name_slug = slugify(project["title"])

                # portfolio/i-love-cats/
                path = File.join(dir, file_name_slug)
                project["dir"] = path

                site.pages << ProjectPage.new(site, site.source, path, project)
            end
        end

        def compute_related_projects(site)
            projects = []
            site.data["projects"].each { |project| projects.push(project[1]) }

            keys = site.config["related_project_keys"]

            projects.each do |project|
                project["related_projects"] = []
                min = site.config["related_min_common"] || 4
                related = projects.clone.keep_if { |project2 | (get_num_matches(project, project2, keys) >= min) }
                related.each { |related_project| project["related_projects"].push(related_project) }
            end
        end

        def get_num_matches(project1, project2, keys)
            total = 0

            unless project1.to_a == project2.to_a
                keys.each { |key| total += get_num_matches_for_key(project1, project2, key) }
            end

            puts "Matches between #{project1["title"]} and #{project2["title"]}: #{total}"

            return total
        end

        def get_num_matches_for_key(project1, project2, key)
            matches = 0

            if project1[key].kind_of?(Array)
                matches = (project1[key] & project2[key]).length()
            else
                if project1[key] == project2[key]
                    matches += 1
                end
            end

            return matches
        end

        def slugify(title)
            title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
        end

    end

    module ProjectFilter
        def get_projects_from_files(input)
            projects = []
            input.each { |project| projects.push(project[1]) }
            return projects
        end
    end

end

Liquid::Template.register_filter(Jekyll::ProjectFilter)
