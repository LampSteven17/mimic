from time import sleep
import os
import random

from ..utility.base_workflow import BaseWorkflow
from ..utility.webdriver_helper import WebDriverHelper
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.wait import WebDriverWait

WORKFLOW_NAME = 'YoutubeBrowser'
WORKFLOW_DESCRIPTION = 'Browse Youtube'

DEFAULT_INPUT_WAIT_TIME = 2
SEARCH_LIST = 'browse_youtube.txt'

def load():
    driver = WebDriverHelper()
    return GoogleSearch(driver=driver)


class GoogleSearch(BaseWorkflow):

    def __init__(self, driver, input_wait_time=DEFAULT_INPUT_WAIT_TIME):
        super().__init__(name=WORKFLOW_NAME, description=WORKFLOW_DESCRIPTION, driver=driver)

        self.input_wait_time = input_wait_time
        self.search_list = self._load_search_list()

    def action(self, extra=None):
        self._search_web()

    """ PRIVATE """

    def _search_web(self):
        random_search = self._get_random_search()

        # Navigate to youtube
        self.driver.driver.get('https://www.youtube.com')
        sleep(random.randrange(2,9))

        # Perform a youtube search   
        search_element = self.driver.driver.find_element_by_css_selector('input#search') # search bar
        search_element.send_keys(random_search)
        search_element.submit()

        # Click on a random video from the search results
        WebDriverWait(self.driver.driver, 10).until(EC.presence_of_all_elements_located((By.ID, "video-title")))
        search_results = self.driver.driver.find_elements_by_id("video-title")
        search_results[random.randrange(0,len(search_results)-1)].click()
        # "Watch" the video for a random amount of time @TODO: Increase the "watch time"
        sleep(random.randrange(2,9))

        # Click on a random video from the suggested videos
        for i in range(0,random.randrange(0,10)):
            sleep(random.randrange(2,9))
            suggested_videos = self.driver.driver.find_elements_by_id("video-title")
            try:
                suggested_videos[random.randrange(0,len(suggested_videos)-1)].click()
            # @ TODO: Investigate this exception
            except Exception as e:
                pass

    def _get_random_search(self):
        search_term = random.choice(self._load_search_list()).rstrip('\n')
        # print(type(search_term), "--"+search_term+"--")
        return search_term

    @staticmethod
    def _load_search_list():
        with open(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..',
                                               'data', SEARCH_LIST))) as f:
            wordlist = f.readlines()
        return wordlist

