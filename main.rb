require 'citeproc'
require 'csl/styles'
require 'bibtex'

biblio = BibTeX.open File.expand_path('./CBG.bib'),
  :include => [:meta_content]

biblio.each_entry {|e| e.title.value.tr!('{}','')}

# To see what styles are available in your current
# environment, run `CSL::Style.ls'; this also works for
# locales as `CSL::Locale.ls'.

# Tell the processor where to find your references. In this
# example we load them from a BibTeX bibliography using the
# bibtex-ruby gem.

cp = CiteProc::Processor.new :style => 'apa',
  :format => 'html', :locale => 'en'

cp.import biblio.to_citeproc

#cp.render :bibliography

content = ""

content += "<ul>"

biblio['@entry, @meta_content'].map do |e|
   if e.entry?
   	content += "<li>"  
   	content += cp.render(:bibliography, id: e.key)[0]
    content += "</li>"  
   else
     e.to_s
   end
end

content += "</ul>"

puts content