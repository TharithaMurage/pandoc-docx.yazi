--- @sync entry
-- pandoc-docx: Bidirectional conversion between Markdown and DOCX

local function entry(_, job)
	local args = job.args or {}
	local reference_doc = args[1]

	local h = cx.active.current.hovered
	if not h then
		ya.notify({ title = "Pandoc", content = "No file selected", level = "warn", timeout = 3 })
		return
	end

	-- Get path and strip file:// prefix
	local url = tostring(h.url)
	local path = url:gsub("^file:///", ""):gsub("^file://", "")

	-- Normalize to forward slashes for pattern matching
	local normalized = path:gsub("\\", "/")

	local ext = normalized:match("%.(%w+)$")
	if not ext then
		ya.notify({ title = "Pandoc", content = "No file extension", level = "warn", timeout = 3 })
		return
	end

	ext = ext:lower()
	local filename = normalized:match("([^/]+)$") or "output"
	local basename = filename:match("(.+)%..+$") or filename
	local dir = normalized:match("(.+)/[^/]+$") or "."

	local cmd, output, output_name

	if ext == "md" or ext == "markdown" then
		-- Markdown -> DOCX
		if not reference_doc then
			ya.notify({ title = "Pandoc", content = "No reference doc specified", level = "error", timeout = 5 })
			return
		end
		output = dir .. "/" .. basename .. ".docx"
		output_name = basename .. ".docx"
		ya.notify({ title = "Pandoc", content = "Converting to DOCX: " .. filename, level = "info", timeout = 2 })
		cmd = string.format('pandoc "%s" -o "%s" --reference-doc="%s"', path, output, reference_doc)

	elseif ext == "docx" then
		-- DOCX -> Markdown
		output = dir .. "/" .. basename .. ".md"
		output_name = basename .. ".md"
		ya.notify({ title = "Pandoc", content = "Converting to Markdown: " .. filename, level = "info", timeout = 2 })
		cmd = string.format('pandoc "%s" -o "%s" --wrap=none --extract-media="%s"', path, output, dir)

	else
		ya.notify({ title = "Pandoc", content = "Unsupported file type: " .. ext, level = "warn", timeout = 3 })
		return
	end

	local exit_code = os.execute(cmd)

	if exit_code == 0 or exit_code == true then
		ya.notify({ title = "Pandoc", content = "Created: " .. output_name, level = "info", timeout = 3 })
	else
		ya.notify({ title = "Pandoc", content = "Conversion failed", level = "error", timeout = 5 })
	end
end

return { entry = entry }
