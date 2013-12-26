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

  def search_form_for(form)

    dropdown_menu_items = []
    form[:key_options].each_pair do |name, value|
      if name.to_sym == form[:search_key]
        item = %Q{
                       <li class="active">
                         <a data-search-key="#{name}" href="#"><span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;按“#{value}”搜索</a>
                       </li>
               }
      else
        item = %Q{
                       <li>
                         <a data-search-key="#{name}" href="#"><span class="glyphicon"></span>&nbsp;&nbsp;按“#{value}”搜索</a>
                       </li>
               }

      end
      dropdown_menu_items << item
    end

    html = <<"EOF"

<form id="search_form" action="#{form[:path]}" method="get">
  <div class="col-lg-offset-6 col-lg-6">
       <div class="input-group">
         <input id="search_value" type="text" name="search_value" class="form-control" value="#{form[:search_value] || ''}" />
         <input id="search_key" type="hidden" name="search_key" value="#{form[:search_key]}"/>
         <div class="input-group-btn">
             <button type="submit" class="btn btn-default">
               <span class="glyphicon glyphicon-search"></span>
               按“#{form[:key_options][form[:search_key]]}”搜索
             </button>
             <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
               <span class="caret"></span>
               <span class="sr-only">Toggle Dropdown</span>
             </button>
             <ul class="dropdown-menu pull-right" role="menu">
               #{dropdown_menu_items.join "\n"}
             </ul>
         </div>
       </div><!-- /input-group -->
  </div>
</form>

  <script type="text/javascript">
    $(document).on("ready page:change", function() {
      var search_form = $("#search_form");
      var search_key_field = $("#search_key");
      menu_items = search_form.find("a[data-search-key]");
      // menu_items.parent.removeClass("active");
      // search_form.find("a[data-search-key=#{form[:search_key]}]").addClass("active");
      menu_items.click(function() {
        var clicked_search_key = $(this).attr("data-search-key");
        search_key_field.val(clicked_search_key);
        search_form.submit();
      });
    });
  </script>
EOF

    html.html_safe
  end
end
