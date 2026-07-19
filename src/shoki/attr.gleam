//// Element creation functions scraped from https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Attributes
//// This list automatically excludes any elements or attributes that are deprecated

// This file is generated. Do not edit by hand

import shoki/element

/// List of types the server accepts, typically a file type.
pub fn accept(value) {
  element.attribute("accept", value)
}

/// The character set, which if provided must be "UTF-8" .
pub fn accept_charset(value) {
  element.attribute("accept-charset", value)
}

/// Keyboard shortcut to activate or add focus to the element.
pub fn accesskey(value) {
  element.attribute("accesskey", value)
}

/// The URI of a program that processes the information submitted via the form.
pub fn action(value) {
  element.attribute("action", value)
}

/// Specifies the horizontal alignment of the element.
pub fn align(value) {
  element.attribute("align", value)
}

/// Specifies a feature-policy for the iframe.
pub fn allow(value) {
  element.attribute("allow", value)
}

/// Allow the user to select a color's opacity on a type="color" input.
pub fn alpha(value) {
  element.attribute("alpha", value)
}

/// Alternative text in case an image can't be displayed.
pub fn alt(value) {
  element.attribute("alt", value)
}

/// Specifies the type of content being loaded by the link.
pub fn as_(value) {
  element.attribute("as", value)
}

/// Executes the script asynchronously.
pub fn async(value) {
  element.attribute("async", value)
}

/// Sets whether input is automatically capitalized when entered by user
pub fn autocapitalize(value) {
  element.attribute("autocapitalize", value)
}

/// Indicates whether controls in this form can by default have their values automatically completed by the browser.
pub fn autocomplete(value) {
  element.attribute("autocomplete", value)
}

/// The audio or video should play as soon as possible.
pub fn autoplay(value) {
  element.attribute("autoplay", value)
}

/// Specifies the URL of an image file. Note: Although browsers and email clients may still support this attribute, it is obsolete. Use CSS background-image instead.
pub fn background(value) {
  element.attribute("background", value)
}

/// Background color of the element. Note: This is a legacy attribute. Please use the CSS background-color property instead.
pub fn bgcolor(value) {
  element.attribute("bgcolor", value)
}

/// The border width. Note: This is a legacy attribute. Please use the CSS border property instead.
pub fn border(value) {
  element.attribute("border", value)
}

/// From the Media Capture specification , specifies a new file can be captured.
pub fn capture(value) {
  element.attribute("capture", value)
}

/// Declares the character encoding of the page or script.
pub fn charset(value) {
  element.attribute("charset", value)
}

/// Indicates whether the element should be checked on page load.
pub fn checked(value) {
  element.attribute("checked", value)
}

/// Contains a URI which points to the source of the quote or change.
pub fn cite(value) {
  element.attribute("cite", value)
}

/// Often used with CSS to style elements with common properties.
pub fn class(value) {
  element.attribute("class", value)
}

/// This attribute sets the text color using either a named color or a color specified in the hexadecimal #RRGGBB format. Note: This is a legacy attribute. Please use the CSS color property instead.
pub fn color(value) {
  element.attribute("color", value)
}

/// Defines the color space that is used by a type="color" input.
pub fn colorspace(value) {
  element.attribute("colorspace", value)
}

/// Defines the number of columns in a textarea.
pub fn cols(value) {
  element.attribute("cols", value)
}

/// The colspan attribute defines the number of columns a cell should span.
pub fn colspan(value) {
  element.attribute("colspan", value)
}

/// A value associated with http-equiv or name depending on the context.
pub fn content(value) {
  element.attribute("content", value)
}

/// Indicates whether the element's content is editable.
pub fn contenteditable(value) {
  element.attribute("contenteditable", value)
}

/// Indicates whether the browser should show playback controls to the user.
pub fn controls(value) {
  element.attribute("controls", value)
}

/// A set of values specifying the coordinates of the hot-spot region.
pub fn coords(value) {
  element.attribute("coords", value)
}

/// How the element handles cross-origin requests
pub fn crossorigin(value) {
  element.attribute("crossorigin", value)
}

/// Specifies the Content Security Policy that an embedded document must agree to enforce upon itself.
pub fn csp(value) {
  element.attribute("csp", value)
}

/// Specifies the URL of the resource.
pub fn data(value) {
  element.attribute("data", value)
}

/// Indicates the date and time associated with the element.
pub fn datetime(value) {
  element.attribute("datetime", value)
}

/// Indicates the preferred method to decode the image.
pub fn decoding(value) {
  element.attribute("decoding", value)
}

/// Indicates that the track should be enabled unless the user's preferences indicate something different.
pub fn default(value) {
  element.attribute("default", value)
}

/// Indicates that the script should be executed after the page has been parsed.
pub fn defer(value) {
  element.attribute("defer", value)
}

/// Defines the text direction. Allowed values are ltr (Left-To-Right) or rtl (Right-To-Left)
pub fn dir(value) {
  element.attribute("dir", value)
}

pub fn dirname(value) {
  element.attribute("dirname", value)
}

/// Indicates whether the user can interact with the element.
pub fn disabled(value) {
  element.attribute("disabled", value)
}

/// Indicates that the hyperlink is to be used for downloading a resource.
pub fn download(value) {
  element.attribute("download", value)
}

/// Defines whether the element can be dragged.
pub fn draggable(value) {
  element.attribute("draggable", value)
}

/// Defines the content type of the form data when the method is POST.
pub fn enctype(value) {
  element.attribute("enctype", value)
}

/// The enterkeyhint specifies what action label (or icon) to present for the enter key on virtual keyboards. The attribute can be used with form controls (such as the value of textarea elements), or in elements in an editing host (e.g., using contenteditable attribute).
pub fn enterkeyhint(value) {
  element.attribute("enterkeyhint", value)
}

/// Indicates that an element is flagged for tracking by PerformanceObserver objects using the "element" type. For more details, see the PerformanceElementTiming interface.
pub fn elementtiming(value) {
  element.attribute("elementtiming", value)
}

/// Signals that fetching a particular image early in the loading process has more or less impact on user experience than a browser can reasonably infer when assigning an internal priority.
pub fn fetchpriority(value) {
  element.attribute("fetchpriority", value)
}

/// Describes elements which belongs to this one.
pub fn for(value) {
  element.attribute("for", value)
}

/// Indicates the form that is the owner of the element.
pub fn form(value) {
  element.attribute("form", value)
}

/// Indicates the action of the element, overriding the action defined in the <form> .
pub fn formaction(value) {
  element.attribute("formaction", value)
}

/// If the button/input is a submit button (e.g., type="submit" ), this attribute sets the encoding type to use during form submission. If this attribute is specified, it overrides the enctype attribute of the button's form owner.
pub fn formenctype(value) {
  element.attribute("formenctype", value)
}

/// If the button/input is a submit button (e.g., type="submit" ), this attribute sets the submission method to use during form submission ( GET , POST , etc.). If this attribute is specified, it overrides the method attribute of the button's form owner.
pub fn formmethod(value) {
  element.attribute("formmethod", value)
}

/// If the button/input is a submit button (e.g., type="submit" ), this boolean attribute specifies that the form is not to be validated when it is submitted. If this attribute is specified, it overrides the novalidate attribute of the button's form owner.
pub fn formnovalidate(value) {
  element.attribute("formnovalidate", value)
}

/// If the button/input is a submit button (e.g., type="submit" ), this attribute specifies the browsing context (for example, tab, window, or inline frame) in which to display the response that is received after submitting the form. If this attribute is specified, it overrides the target attribute of the button's form owner.
pub fn formtarget(value) {
  element.attribute("formtarget", value)
}

/// IDs of the <th> elements which applies to this element.
pub fn headers(value) {
  element.attribute("headers", value)
}

/// Specifies the height of elements listed here. For all other elements, use the CSS height property. Note: In some instances, such as <div> , this is a legacy attribute, in which case the CSS height property should be used instead.
pub fn height(value) {
  element.attribute("height", value)
}

/// Prevents rendering of given element, while keeping child elements, e.g. script elements, active.
pub fn hidden(value) {
  element.attribute("hidden", value)
}

/// Indicates the lower bound of the upper range.
pub fn high(value) {
  element.attribute("high", value)
}

/// The URL of a linked resource.
pub fn href(value) {
  element.attribute("href", value)
}

/// Specifies the language of the linked resource.
pub fn hreflang(value) {
  element.attribute("hreflang", value)
}

/// Defines a pragma directive.
pub fn http_equiv(value) {
  element.attribute("http-equiv", value)
}

/// Often used with CSS to style a specific element. The value of this attribute must be unique.
pub fn id(value) {
  element.attribute("id", value)
}

/// This attribute contains one or more hashes of the resource, and is used to ensure that the content of the resource is what the developer expects it to be, and has not been replaced with a malicious copy in a supply chain attack . See Subresource Integrity .
pub fn integrity(value) {
  element.attribute("integrity", value)
}

/// Provides a hint as to the type of data that might be entered by the user while editing the element or its contents. The attribute can be used with form controls (such as the value of textarea elements), or in elements in an editing host (e.g., using contenteditable attribute).
pub fn inputmode(value) {
  element.attribute("inputmode", value)
}

/// Indicates that the image is part of a server-side image map.
pub fn ismap(value) {
  element.attribute("ismap", value)
}

pub fn itemprop(value) {
  element.attribute("itemprop", value)
}

/// Specifies the kind of text track.
pub fn kind(value) {
  element.attribute("kind", value)
}

/// Specifies a user-readable title of the element.
pub fn label(value) {
  element.attribute("label", value)
}

/// Defines the language used in the element.
pub fn lang(value) {
  element.attribute("lang", value)
}

/// Defines the script language used in the element.
pub fn language(value) {
  element.attribute("language", value)
}

/// Indicates if the element should be loaded lazily ( loading="lazy" ) or loaded immediately ( loading="eager" ).
pub fn loading(value) {
  element.attribute("loading", value)
}

/// Identifies a list of pre-defined options to suggest to the user.
pub fn list(value) {
  element.attribute("list", value)
}

/// Indicates whether the media should start playing from the start when it's finished.
pub fn loop(value) {
  element.attribute("loop", value)
}

/// Indicates the upper bound of the lower range.
pub fn low(value) {
  element.attribute("low", value)
}

/// Indicates the maximum value allowed.
pub fn max(value) {
  element.attribute("max", value)
}

/// Defines the maximum number of characters allowed in the element.
pub fn maxlength(value) {
  element.attribute("maxlength", value)
}

/// Defines the minimum number of characters allowed in the element.
pub fn minlength(value) {
  element.attribute("minlength", value)
}

/// Specifies a hint of the media for which the linked resource was designed.
pub fn media(value) {
  element.attribute("media", value)
}

/// Defines which HTTP method to use when submitting the form. Can be GET (default) or POST .
pub fn method(value) {
  element.attribute("method", value)
}

/// Indicates the minimum value allowed.
pub fn min(value) {
  element.attribute("min", value)
}

/// Indicates whether multiple values can be entered in an input of the type email or file .
pub fn multiple(value) {
  element.attribute("multiple", value)
}

/// Indicates whether the audio will be initially silenced on page load.
pub fn muted(value) {
  element.attribute("muted", value)
}

/// Name of the element. For example used by the server to identify the fields in form submits.
pub fn name(value) {
  element.attribute("name", value)
}

/// This attribute indicates that the form shouldn't be validated when submitted.
pub fn novalidate(value) {
  element.attribute("novalidate", value)
}

/// Indicates whether the contents are currently visible (in the case of a <details> element) or whether the dialog is active and can be interacted with (in the case of a <dialog> element).
pub fn open(value) {
  element.attribute("open", value)
}

/// Indicates the optimal numeric value.
pub fn optimum(value) {
  element.attribute("optimum", value)
}

/// Defines a regular expression which the element's value will be validated against.
pub fn pattern(value) {
  element.attribute("pattern", value)
}

/// The ping attribute specifies a space-separated list of URLs to be notified if a user follows the hyperlink.
pub fn ping(value) {
  element.attribute("ping", value)
}

/// Provides a hint to the user of what can be entered in the field.
pub fn placeholder(value) {
  element.attribute("placeholder", value)
}

/// A Boolean attribute indicating that the video is to be played "inline"; that is, within the element's playback area. Note that the absence of this attribute does not imply that the video will always be played in fullscreen.
pub fn playsinline(value) {
  element.attribute("playsinline", value)
}

/// A URL indicating a poster frame to show until the user plays or seeks.
pub fn poster(value) {
  element.attribute("poster", value)
}

/// Indicates whether the whole resource, parts of it or nothing should be preloaded.
pub fn preload(value) {
  element.attribute("preload", value)
}

/// Indicates whether the element can be edited.
pub fn readonly(value) {
  element.attribute("readonly", value)
}

/// Specifies which referrer is sent when fetching the resource.
pub fn referrerpolicy(value) {
  element.attribute("referrerpolicy", value)
}

/// Specifies the relationship of the target object to the link object.
pub fn rel(value) {
  element.attribute("rel", value)
}

/// Indicates whether this element is required to fill out or not.
pub fn required(value) {
  element.attribute("required", value)
}

/// Indicates whether the list should be displayed in a descending order instead of an ascending order.
pub fn reversed(value) {
  element.attribute("reversed", value)
}

/// Defines an explicit role for an element for use by assistive technologies.
pub fn role(value) {
  element.attribute("role", value)
}

/// Defines the number of rows in a text area.
pub fn rows(value) {
  element.attribute("rows", value)
}

/// Defines the number of rows a table cell should span over.
pub fn rowspan(value) {
  element.attribute("rowspan", value)
}

/// Stops a document loaded in an iframe from using certain features (such as submitting forms or opening new windows).
pub fn sandbox(value) {
  element.attribute("sandbox", value)
}

/// Defines the cells that the header test (defined in the th element) relates to.
pub fn scope(value) {
  element.attribute("scope", value)
}

/// Defines a value which will be selected on page load.
pub fn selected(value) {
  element.attribute("selected", value)
}

pub fn shape(value) {
  element.attribute("shape", value)
}

/// Defines the width of the element (in pixels). If the element's type attribute is text or password then it's the number of characters.
pub fn size(value) {
  element.attribute("size", value)
}

pub fn sizes(value) {
  element.attribute("sizes", value)
}

/// Assigns a slot in a shadow DOM shadow tree to an element.
pub fn slot(value) {
  element.attribute("slot", value)
}

pub fn span(value) {
  element.attribute("span", value)
}

/// Indicates whether spell checking is allowed for the element.
pub fn spellcheck(value) {
  element.attribute("spellcheck", value)
}

/// The URL of the embeddable content.
pub fn src(value) {
  element.attribute("src", value)
}

pub fn srcdoc(value) {
  element.attribute("srcdoc", value)
}

pub fn srclang(value) {
  element.attribute("srclang", value)
}

/// One or more responsive image candidates.
pub fn srcset(value) {
  element.attribute("srcset", value)
}

/// Defines the first number if other than 1.
pub fn start(value) {
  element.attribute("start", value)
}

pub fn step(value) {
  element.attribute("step", value)
}

/// Defines CSS styles which will override styles previously set.
pub fn style(value) {
  element.attribute("style", value)
}

pub fn summary(value) {
  element.attribute("summary", value)
}

/// Overrides the browser's default tab order and follows the one specified instead.
pub fn tabindex(value) {
  element.attribute("tabindex", value)
}

/// Specifies where to open the linked document (in the case of an <a> element) or where to display the response received (in the case of a <form> element)
pub fn target(value) {
  element.attribute("target", value)
}

/// Text to be displayed in a tooltip when hovering over the element.
pub fn title(value) {
  element.attribute("title", value)
}

/// Specify whether an element's attribute values and the values of its Text node children are to be translated when the page is localized, or whether to leave them unchanged.
pub fn translate(value) {
  element.attribute("translate", value)
}

/// Defines the type of the element.
pub fn type_(value) {
  element.attribute("type", value)
}

pub fn usemap(value) {
  element.attribute("usemap", value)
}

/// Defines a default value which will be displayed in the element on page load.
pub fn value(value) {
  element.attribute("value", value)
}

/// For the elements listed here, this establishes the element's width. Note: For all other instances, such as <div> , this is a legacy attribute, in which case the CSS width property should be used instead.
pub fn width(value) {
  element.attribute("width", value)
}

/// Indicates whether the text should be wrapped.
pub fn wrap(value) {
  element.attribute("wrap", value)
}
