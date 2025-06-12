import scrapy

class BookSpider(scrapy.Spider):
    name = 'books'
    start_urls = ['https://books.toscrape.com/']

    def parse(self, response):
        books = response.css('article.product_pod')

        for book in books:
            title = book.css('h3 a::attr(title)').get()
            price = book.css('p.price_color::text').get()
            rating_class = book.css('p.star-rating::attr(class)').get()
            rating = rating_class.replace('star-rating', '').strip() if rating_class else 'Not Rated'
            availability = ''.join(book.css('p.instock.availability::text').getall()).strip()


            yield {
                'Title': title,
                'Price': price,
                'Rating': rating,
                'Availability': availability
            }

       
        next_page = response.css('li.next a::attr(href)').get()
        if next_page:
            yield response.follow(next_page, callback=self.parse)
