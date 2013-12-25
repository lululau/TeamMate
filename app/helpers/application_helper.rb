module ApplicationHelper
  def markdown(text)
    options = {
      :autolink => true,
      :space_after_headers => true,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :hard_wrap => true,
      :strikethrough =>true
    }
    markdown = Redcarpet::Markdown.new(HTMLwithCodeRay,options)
    html = markdown.render(text.gsub("\r\n", "\n"))

    html.gsub! /\[\[([^\[\]]*?)\]\]/ do
      subject = $1
      if subject =~ /([^:]*?):(.*)/
        project_name = $1
        subject = $2
        project = Project.find_by :name => project_name
        if project
          link_to($&, project_show_or_new_wiki_path(project, @wiki, subject))
        else
          "[[#{project_name}:#{subject}]]"
        end
      else
        link_to(subject, project_show_or_new_wiki_path(@project, @wiki, subject))
      end
    end

    html.html_safe
  end

  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div(:tab_width=>2)
    end
  end

  def wiki_tree_html(wiki)
    descendent_htmls = []

    wiki.children.any? and wiki.children.each do |child|
      descendent_htmls << wiki_tree_html(child)
    end

    html = <<"EOF"
   <li>
   <span class="glyphicon glyphicon-#{descendent_htmls.any? ? 'minus' : 'minus'}-sign"> </span> #{link_to wiki.subject, (wiki.parent_id.present? ? project_show_or_new_wiki_path(@project, wiki.parent_id, wiki.subject) : project_root_wiki_path(@project)) }
   <ul>
     #{descendent_htmls.join("\n")}
   </ul>
   </li>
EOF
  end

  def avatar_path(obj)
    if obj === Integer
      avatar_id = obj
    else
      avatar_id = obj.avatar
    end
    "/images/avatar/#{avatar_id || 0}.png"
  end

  def role_level_lt_me(user)
    roles = {
      nil => 1,
      "normal" => 1,
      "manager"  => 2,
      "admin" => 3
    }
    my_role = roles[current_user.role]
    user_role = roles[user.role]
    return user_role < my_role
  end
end
